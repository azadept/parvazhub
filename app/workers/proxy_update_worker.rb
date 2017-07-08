require 'sidekiq-scheduler'

class ProxyUpdateWorker
  include Sidekiq::Worker
  sidekiq_options :retry => true, :backtrace => true
 
  def perform
     worker = Proxy.new
     worker.update_proxy
  end
end