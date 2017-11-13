require 'test_helper'

class SuppliersZoraqTest < ActiveSupport::TestCase

  def setup
    @zoraq_search = Suppliers::Zoraq.new
    @origin = "thr"
    @destination = "mhd"
    @date = "2017-06-20"
    @search_history_id = 1
  end
    
  test "Zoraq code should retrun with correct one" do
    atrak = @zoraq_search.airline_code_correction("@1")
    mahan =  @zoraq_search.airline_code_correction("w5")

    assert_equal(atrak,"AK")
    assert_equal(mahan,"W5")

  end
  
  test "Zoraq search should answered with hash response" do
    response = @zoraq_search.search(@origin,@destination,@date,@search_history_id)
    assert response.is_a? Hash
    assert_not response[:response].empty?
  end

  test "Zoraq international search should answered with hash response" do
    response = @zoraq_search.search("thr","ist",@date,@search_history_id)
    assert response.is_a? Hash
    assert_not response[:response].empty?
  end

  test "flights from zoraq should saved to flights table" do
    response = @zoraq_search.search(@origin,@destination,@date,@search_history_id)
    route = Route.find_by(origin:@origin,destination:@destination)
    assert_difference 'Flight.count', 7 do
      @zoraq_search.import_domestic_flights(response,route.id,@origin,@destination,@date,@search_history_id)
    end
  end

  test "international flights from zoraq should saved to flights table" do
    response = @zoraq_search.search("thr","ist",@date,@search_history_id)
    route = Route.find_by(origin:"thr",destination:"ist")
    assert_difference 'Flight.count', 87 do
      @zoraq_search.import_domestic_flights(response,route.id,"thr","ist",@date,@search_history_id)
    end
  end

  test "flight prices from zoraq should saved" do
    response = @zoraq_search.search(@origin,@destination,@date,@search_history_id)
    route = Route.find_by(origin:@origin,destination:@destination)
    assert_difference 'FlightPrice.count', 7 do
      @zoraq_search.import_domestic_flights(response,route.id,@origin,@destination,@date,@search_history_id)
    end
  end

  test "zoraq deeplink for today should be goes to checkout page" do
    date = Date.today.to_s
    fare_source_code = "/Flight/Checkout/?sessionKey=6405f715-e704-4030-b9e4-cd2c2401f2b1&identifier=c32867c9-2dbe-4b42-9871-41df8382a220&searchType=DomesticFlights"
    deeplink = @zoraq_search.get_zoraq_deeplink(@origin,@destination,date,fare_source_code)
    assert deeplink.include? "Checkout"
  end

  test "zoraq deeplink for days after today should be goes to list page" do
    date = (Date.today+1).to_s
    fare_source_code = "/Flight/Checkout/?sessionKey=6405f715-e704-4030-b9e4-cd2c2401f2b1&identifier=c32867c9-2dbe-4b42-9871-41df8382a220&searchType=DomesticFlights"
    deeplink = @zoraq_search.get_zoraq_deeplink(@origin,@destination,date,fare_source_code)
    assert deeplink.include? "Iran/Mashhad"
    assert deeplink.include? "مشهد"
    assert deeplink.include? "تهران"
  end

  test "calculate stop overs" do
    arrivals = ["2017-11-19 18:00:00".to_datetime,"2017-11-19 20:00:00".to_datetime,"2017-11-19 23:00:00".to_datetime]
    departures = ["2017-11-19 14:00:00".to_datetime,"2017-11-19 19:00:00".to_datetime,"2017-11-19 22:00:00".to_datetime]
    
    assert_equal  @zoraq_search.calculate_stopover_duration(["2017-11-19 18:00:00".to_datetime],["2017-11-19 18:00:00".to_datetime]),0 
    assert_equal  @zoraq_search.calculate_stopover_duration(departures,arrivals),180

  end

  

end