class SearchController < ApplicationController

  def flight
  end

  def search_proccess
    origin = params[:search][:origin].downcase
    destination = params[:search][:destination].downcase
    date = params[:search][:date]
    route = Route.find_by(origin: "#{origin}", destination:"#{destination}")

    
    #search on suppliers
    search_suppliers(origin,destination,route.id,date)
    
    results(route,date)
  end

  def search_suppliers(origin,destination,route_id,date)
    zoraq_response = Suppliers::Zoraq.search(origin,destination,date)
    log(zoraq_response)
    flight_list = Flight.new()
    flight_list.import_zoraq_flights(zoraq_response,route_id)
  end

  def results(route,date)
     @flights = route.flights.where(departure_time: date.to_date.beginning_of_day..date.to_date.end_of_day)
      #debugger
     render :results
  end

  def log(response)
    log_file_path_name = "log/supplier/"+Time.now.to_s+".log"
    log_file = File.new("#{log_file_path_name}", "w")
    log_file.puts(response)
    log_file.close
  end

  



end