require 'google/apis/analyticsreporting_v4'

class QueryGoogleApiWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(shop_id)
    ## lookup the user to get the access_token
    shop = Shop.find(shop_id)
    client = Signet::OAuth2::Client.new(access_token: shop.latest_access_token)
    client.expires_in = Time.now + 1_000_000 ## TODO research more here
    service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    service.authorization = client
    @account_summaries = service.batch_report_get
    puts '*'*50
    puts @account_summaries.reports
  end
end