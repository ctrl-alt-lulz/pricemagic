require 'signet/oauth_2/client'
require 'google/apis/analyticsreporting_v4'

class QueryGoogleApiWorker
  include Google::Apis::AnalyticsreportingV4
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(shop_id)
    shop = Shop.find(shop_id)
    @view_id = shop.google_profile_id
    @start_date = "#{(Time.now - shop.created_at).to_i / (24 * 60 * 60)}daysago"
    client = Signet::OAuth2::Client.new(client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
                                        client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
                                        access_token: shop.latest_access_token,
                                        refresh_token: shop.latest_refresh_token,
                                        token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token')
    client.refresh! if client.expired?
    # time convert created at to google format strftime("%Y-%m-%d")
    # time = Metric.last.created_at
    service = AnalyticsReportingService.new
    service.authorization = client
    begin
      @product_performance = service.batch_report_get(get_product_performance)
      ::Metric.bulk_metric_create_from_google!(shop.id, @product_performance)
      ## TODO write worker to check price_tests for upgrades/closing
      ## CheckPriceTestsWorker.perform_async(shop_id)
    end
  end
  
  private
  
  def get_product_performance
    rr = default_rr([metric(expression: "ga:itemRevenue"), 
    metric(expression: "ga:productDetailViews"),
    metric(expression: "ga:revenuePerItem")], [dimension(name: 'ga:productName')])
    rr.order_bys = [sort(sort_order: "descending", field_name: "ga:itemRevenue")]
    return grr([rr])
  end
  
  def default_rr(metrics, dimensions)
    rr = rrq(view_id: @view_id, 
            date_ranges: [date(start_date: @start_date, end_date: 'today')],
            metrics: metrics,
            dimensions: dimensions)
    return rr
  end
  
  def grr(params)
    grr = GetReportsRequest.new
    grr.report_requests = params
    return grr
  end
  
  def rrq(params)
    ReportRequest.new(params)
  end
  
  def metric(params)
    Metric.new(params)
  end
  
  def sort(params)
    OrderBy.new(params)
  end
  
  def dimension(params)
    Dimension.new(params)
  end
  
  def date(params)
    DateRange.new(params)
  end
end
