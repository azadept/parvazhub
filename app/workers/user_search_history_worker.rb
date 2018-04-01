require 'sidekiq-scheduler'

class UserSearchHistoryWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true, :queue => 'low'
 
  def perform(route_id,date,channel,user)
    Timeout.timeout(60) do
      UserSearchHistory.create(route_id:route_id,
                               departure_time:"#{date}",
                               channel:channel,
                               user: user) #save user search to show in admin panel      
    end
  end

end