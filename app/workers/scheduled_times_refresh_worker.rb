class ScheduledTimesRefreshWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'default'

  def perform
    stop_pairs_map = {}
    Scheduled::Route.all.each do |route|
      Scheduled::Trip.soon_grouped(Time.current.to_i, route.id).each do |_, trips|
        trips.each do |trip|
          trip.stop_times.each_cons(2) do |a_st, b_st|
            time = b_st.departure_time - a_st.departure_time
            stop_pairs_map[[a_st.stop_internal_id, b_st.stop_internal_id]] = time
          end
        end
      end
    end

    REDIS_CLIENT.pipelined do |pipeline|
      stop_pairs_map.each do |(a_st, b_st), time|
        RedisStore.add_scheduled_travel_time(a_st, b_st, time, pipeline)
      end
    end
  end
end
