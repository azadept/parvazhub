class AddIndexToFlight < ActiveRecord::Migration[5.0]
  def change
  	    #add_index :route_id, :flight_number, :departure_time, unique: true
  	    add_index :flights, [:route_id, :flight_number, :departure_time],  unique: true
  end
end
