class SearchController < ApplicationController
  def flight
  end

  def search_proccess
    origin = params[:search][:origin].downcase
    destination = params[:search][:destination].downcase
    date = params[:search][:date]
    route_id = Route.route_id(origin,destination)
    
    search_suppliers(origin,destination,route_id,date)
    
    render :test #html: route_id
  end

  def search_suppliers(origin,destination,route_id,date)
    zoraq_response = Suppliers::Zoraq.search(origin,destination,date)
    log(zoraq_response)
    flight_list = Flight.new()
    flight_list.import_zoraq_flights(zoraq_response,route_id)
  end

  def test
    logger.debug "this is test"
  end

  def log(response)
    log_file_path_name = "log/supplier/"+Time.now.to_s+".log"
    log_file = File.new("#{log_file_path_name}", "w")
    log_file.puts(response)
    log_file.close
  end



end