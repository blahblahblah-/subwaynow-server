class UpdateBusTransfersQueensBusRedesign < ActiveRecord::Migration[7.1]
  def change
    Scheduled::BusTransfer.find_by!(from_stop_internal_id: "702", bus_route: "Q48 to LGA").destroy
    Scheduled::BusTransfer.find_by!(from_stop_internal_id: "701", bus_route: "Q48 to LGA").destroy

    Scheduled::BusTransfer.create!(from_stop_internal_id: "701", bus_route: "Q90 to LGA", airport_connection: true, access_time_from: 18000, access_time_to: 86399)

    Scheduled::BusTransfer.find_by!(from_stop_internal_id: "710", bus_route: "Q47 to LGA").destroy
    Scheduled::BusTransfer.find_by!(from_stop_internal_id: "G14", bus_route: "Q47 to LGA").destroy

    Scheduled::BusTransfer.create!(from_stop_internal_id: "710", bus_route: "Q33 to LGA", airport_connection: true)
    Scheduled::BusTransfer.create!(from_stop_internal_id: "709", bus_route: "Q33 to LGA", airport_connection: true)
    Scheduled::BusTransfer.create!(from_stop_internal_id: "G14", bus_route: "Q33 to LGA", airport_connection: true)

    Scheduled::BusTransfer.create!(from_stop_internal_id: "J12", bus_route: "Q80 to JFK", airport_connection: true)
  end
end
