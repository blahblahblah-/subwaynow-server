class RouteStopTracksRefreshWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: 'default'

  def perform
    stop_tracks = RedisStore.stop_tracks
    routes_stop_tracks_futures = {}

    REDIS_CLIENT.pipelined do |pipeline|
      routes_stop_tracks_futures = stop_tracks.to_h do |s|
        array = s.split(':')
        ["#{array[0]}-#{array[1]}", RedisStore.routes_stop_at_track(array[0], array[1], Time.current.to_i, pipeline)]
      end
    end

    data = routes_stop_tracks_futures.to_h { |id, sf|
      [id, sf.value]
    }
    RedisStore.update_routes_stop_tracks(data.to_json)
  end
end
