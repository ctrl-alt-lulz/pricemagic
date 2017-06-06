class QueryGoogleApiWorker
  include Sidekiq::Worker
  def perform
      puts "Hello world"
  end
end