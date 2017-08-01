require 'signet/oauth_2/client'
require 'google/apis/analyticsreporting_v4'
class GoogleAuthController < ApplicationController
  def show
  end

  def new
    client = ::Signet::OAuth2::Client.new({
      client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: "profile #{::Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS_READONLY}",
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
    user  = current_shop.users.new
    user.google_access_token = response['access_token']
    user.google_refresh_token = response['refresh_token']
    user.save
    redirect_to root_url
  end
end

