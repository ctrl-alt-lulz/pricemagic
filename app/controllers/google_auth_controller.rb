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
      scope: ::Google::Apis::AnalyticsreportingV4::AUTH_ANALYTICS_READONLY,
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
      redirect_uri: "https://533e004c.ngrok.io/oauth2callback", ## TODO put this in .env
      code: params[:code]
    })
    response = client.fetch_access_token!
    puts '*'*50
    #puts response.inspect
    puts '*'*50
    session[:access_token] = response['access_token']
    puts cookies[:shopify_domain]

    ## TODO store access_token on user
    # current_user.access_token = response['access_token']
    # current_user.save

    ## TODO redirect back to index (or wherever they started)
    ## redirect_to admin_products_path
    redirect_to url_for(:action => :analytics)
  end
end
