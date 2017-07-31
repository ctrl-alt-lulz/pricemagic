require 'signet/oauth_2/client'
require 'google/apis/analyticsreporting_v4'

class QueryGoogleApiWorker
  include Google::Apis::AnalyticsreportingV4
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(shop_id)
    ## TODO store the refresh_token so we can use the refresh_token to
    ## get updated access_tokens when they expire
    shop = Shop.find(shop_id)
    client = Signet::OAuth2::Client.new(access_token: shop.latest_access_token,
                                        refresh_token: shop.latest_refresh_token)
    client.update_token!
    client.expires_in = Time.now + 1_000_000 ## TODO research more here
    ## TODO verify this offline access is necessary and/how to use properly
    ## client.update!(:additional_parameters => {"access_type" => "offline"})
    ## https://developers.google.com/identity/protocols/OAuth2WebServer#offline
    # session[:expires_in] = client.expires_in
    # session[:issued_at] = client.issued_at
    service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    service.authorization = client
    begin
      @product_performance = service.batch_report_get(get_product_performance)
      shop.metrics.create(data: @product_performance)
      ## TODO figure out how to relate to a product
      ## product.metrics.create(type: 'Summary', data: @account_summaries)
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
    rr = rrq(view_id: "136801755", 
            date_ranges: [date(start_date: '180daysago', end_date: 'today')],
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
