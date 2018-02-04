require 'signet/oauth_2/client'
require 'google/apis/analyticsreporting_v4'
require 'google/apis/analytics_v3'

class GoogleAuthController < ApplicationController
  def show
  end

  def new
    client = ::Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: "#{Google::Apis::AnalyticsV3::AUTH_ANALYTICS_READONLY} 
              #{::Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS_READONLY}",
      redirect_uri: Rails.configuration.public_url + "oauth2callback",
      token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token',
    })
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      redirect_uri: Rails.configuration.public_url + "oauth2callback", 
      code: params[:code],
    })
    response = client.fetch_access_token!
    service = Google::Apis::AnalyticsV3::AnalyticsService.new
    service.authorization = client
    user  = current_shop.users.first_or_initialize
    user.google_access_token = response['access_token']
    user.google_refresh_token = response['refresh_token'] unless response['refresh_token'].nil?
    user.google_profile_id = find_google_account_id(service)
    user.save
    redirect_to root_url
  end
  
  def destroy
    uri = URI('https://accounts.google.com/o/oauth2/revoke')
    params = { :token => current_shop.latest_access_token }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get(uri)
    shop = GoogleAuth::Destroy.call(current_shop)
    if shop.errors.empty?
      redirect_to recurring_charges_path, notice: 'Google removed!'
    else
      puts response.inspect
      redirect_to recurring_charges_path, error: 'Something went wrong.'
    end
  end
  
  private 
  
  def find_google_account_id(service)
    current_shop.with_shopify!
    domain = strip_to_base_url(ShopifyAPI::Shop.current.domain)
    service.list_management_account_summaries.items.map do |item|
      url = item.web_properties[0].website_url
      url = strip_to_base_url(url)
      if (!!url.match(/^#{domain}$/))
        id = item.web_properties[0].profiles[0].id
        return id
      end
    end
  end
  
  def strip_to_base_url(url)
    url = url.strip.gsub(/\Ahttps?:\/\//, '')
    if idx = url.index(".")
      url = url.slice(0, idx)
    end
    return url
  end
end