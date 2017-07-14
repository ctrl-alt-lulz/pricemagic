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
    #@account_summaries = service.batch_get_reports(get_account_summaries)
  end
end

  # def analytics
  #   ## lookup the user to get the access_token
  #   client = Signet::OAuth2::Client.new(access_token: session[:access_token])
  #   client.expires_in = Time.now + 1_000_000 ## TODO research more here
  #   service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
  #   service.authorization = client
  #   begin
  #     @account_summaries = service.batch_get_reports(get_account_summaries)
  #     @product_revenue = service.batch_get_reports(get_product_revenue)
  #     @product_performance = service.batch_get_reports(get_product_performance)
  #   rescue
  #     redirect_to google_auth_path
  #   end
  # end
  
  # private
  
  # def get_account_summaries
  #   rr = default_rr([metric(expression: "ga:uniquePageviews")],
  #                   [dimension(name: 'ga:pageTitle'),dimension(name: 'ga:pagePath')])
  #   rr.filters_expression = "ga:pagePath=~collections,ga:pagePath=~products"
  #   rr.order_bys = [sort(sort_order: "descending", field_name: "ga:uniquePageviews")]
  #   return grr([rr])
  # end
  
  # def get_product_revenue
  #   rr = default_rr([metric(expression: "ga:itemRevenue")], [dimension(name: 'ga:productName')])
  #   return grr([rr])
  # end
  
  # def get_product_performance
  #   rr = default_rr([metric(expression: "ga:itemRevenue"), metric(expression: "ga:productDetailViews"),
  #   metric(expression: "ga:revenuePerItem")], [dimension(name: 'ga:productName')])
  #   rr.order_bys = [sort(sort_order: "descending", field_name: "ga:itemRevenue")]
  #   return grr([rr])
  # end
  
  # def default_rr(metrics, dimensions)
  #   rr = rrq(view_id: "136801755", 
  #           date_ranges: [date(start_date: '180daysago', end_date: 'today')],
  #           metrics: metrics,
  #           dimensions: dimensions)
  #   return rr
  # end
  
  # def grr(params)
  #   grr = GetReportsRequest.new
  #   grr.report_requests = params
  #   return grr
  # end
  
  # def rrq(params)
  #   ReportRequest.new(params)
  # end
  
  # def metric(params)
  #   Metric.new(params)
  # end
  
  # def sort(params)
  #   OrderBy.new(params)
  # end
  
  # def dimension(params)
  #   Dimension.new(params)
  # end
  
  # def date(params)
  #   DateRange.new(params)
  # end