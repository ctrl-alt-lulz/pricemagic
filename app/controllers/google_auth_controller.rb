require 'signet/oauth_2/client'
require 'google/apis/analytics_v3'
class GoogleAuthController < ApplicationController
  def show
  end

  def new
    client = ::Signet::OAuth2::Client.new({
    client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
    client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
    authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
    scope: ::Google::Apis::AnalyticsV3::AUTH_ANALYTICS_READONLY,
    redirect_uri: "https://533e004c.ngrok.io/oauth2callback",
    token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token',
    })
    redirect_to client.authorization_uri.to_s
  end


  def callback
    client = Signet::OAuth2::Client.new({
    client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
    client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
    token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
    redirect_uri: "https://533e004c.ngrok.io/oauth2callback",
    code: params[:code]
  })
    response = client.fetch_access_token!
    session[:access_token] = response['access_token']
    redirect_to url_for(:action => :analytics)
  end

  def analytics
    client = Signet::OAuth2::Client.new(access_token: session[:access_token])
    client.expires_in = Time.now + 1_000_000
    service = Google::Apis::AnalyticsV3::AnalyticsService.new
    service.authorization = client
    @account_summaries = service.list_management_account_summaries
  end
end
