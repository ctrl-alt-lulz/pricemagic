class QueryGoogleApiWorker
  include Sidekiq::Worker

  def perform
    ## lookup the user to get the access_token
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])
    client.expires_in = Time.now + 1_000_000 ## TODO research more here
    service = Google::Apis::AnalyticsreportingV4::AnalyticsService.new
    service.authorization = client
    @account_summaries = service.list_management_account_summaries
  end
end