class Airports::DomesticAirport
  
  
   
  def self.airports
    [
      ["mashhad","mhd",139],
      ["tabriz","tbz",34],
      ["shiraz","syz",81],
      ["ahwaz","awz",42],
      ["isfahan","ifn",50],
      ["kerman","ker",11],
      ["sari","sry",4],
      ["rasht","ras",9],
      ["yazd","azd",19],
      ["kermanshah","ksh",9],
      ["bandarabbas","bnd",13],
      ["zahedan","zah",12],
      ["bushehr","buz",13],
      ["gorgan","gbt",10],
      ["ardabil","adu",7]
    ]
  end
  
  def self.unnormal_airport 
    [["mehrabad","thr","Airports::Mehrabad"],["abadan","abd","Airports::Abadan"]]
  end
  

  def search(city_name)
    get_flight_url = "https://#{city_name}.airport.ir/flight-info"
  
    begin
      if Rails.env.test?
        response = File.read("test/fixtures/files/#{city_name}.log") 
      else
        #response = RestClient.get("#{URI.parse(get_flight_url)}")
        response = RestClient::Request.execute(:url => "#{URI.parse(get_flight_url)}", :method => :get, :verify_ssl => false)
        
    end
    rescue
      return false
    end
    return response
  end

  def import_domestic_flights(response,city_code)
    flight_details = Array.new()
    origin = city_code
    doc = Nokogiri::HTML(response)
    doc = doc.xpath('//*[@id="dep-flights-info"]/tbody/tr')

    doc.each do |flight|

      destination_name_in_persian = flight.css(".cell-dest p").text
      destination = City.get_city_code_based_on_name destination_name_in_persian

      next if destination == false #we dont want all cities

      route = Route.find_by(origin:"#{origin}",destination:"#{destination}")
      call_sign = flight.css(".cell-fno p").text
      actual_departure_time = flight.css(".cell-airline p")[1].text
      status = flight.css(".cell-status p").text.tr("|","")
      airplane_type = flight.css(".cell-aircraft p").text
      departure_time = (flight.css(".cell-time p").text+(":00"))
      day = flight.css(".cell-day p").text
      departure_date_time = get_date_time(day,departure_time)
      #airline = flight.css(".cell-airline p").text

      unless actual_departure_time.empty? 
        actual_departure_time = convert_to_gregorian actual_departure_time
      end

      FlightDetail.create(route_id: "#{route.id}",
        call_sign: "#{call_sign}",
        departure_time: "#{departure_date_time}",
        airplane_type: "#{airplane_type}",
        status: "#{status}",
        actual_departure_time:"#{actual_departure_time}")

    end
  end


  def convert_to_gregorian shamsi_date
    date = Parsi::DateTime.parse shamsi_date
    date = date.to_gregorian.to_date.to_s
    date += " "+shamsi_date[11..-1]
    date.to_datetime
  end

  def get_date_time(day,time)
    yesterday_datetime = (Time.now.to_date-1).to_s + " #{time}"
    today_datetime = (Time.now.to_date).to_s + " #{time}"
    tomorrow_datetime = (Time.now.to_date+1).to_s + " #{time}"

    yesterday_name = ((Time.now.to_date-1).strftime '%A').downcase
    today_name = (Time.now.to_date.strftime '%A').downcase
    tomorrow_name = ((Time.now.to_date+1).strftime '%A').downcase

    if get_english_name(day) == yesterday_name
      return yesterday_datetime.to_datetime
    elsif get_english_name(day) == today_name
      return today_datetime.to_datetime
    else
      return tomorrow_datetime.to_datetime
    end
  end

  def get_english_name day
    case day
	  when "شنبه"
	  	en_day_name = "saturday"
    when "یکشنبه", "یک شنبه", "یک‌شنبه"
	  	en_day_name = "sunday"
    when "دوشنبه", "دو شنبه"
	  	en_day_name = "monday"
    when  "سهشنبه", "سه شنبه", "سه‌شنبه"
	  	en_day_name = "tuesday"
    when "چهارشنبه", "چهار شنبه"
	  	en_day_name = "wednesday"
    when "پنجشنبه", "پنج شنبه", "پنج‌شنبه"
	  	en_day_name = "thursday"
    when "جمعه"
	  	en_day_name = "friday"
    end
    return en_day_name
  end

 
  

end