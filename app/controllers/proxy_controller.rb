require 'rubygems'
require 'openssl'
require 'rack/utils'

# ProxyController
# accept ApplicationProxy requests from Shopify
# validate the request
# call appropriate action
# return .liquid
class ProxyController < ApplicationController
	before_action :get_query
	before_action :validate_proxy
	
	# GET /proxy
	def index	
		# show app proxy here
		render({
			content_type: 'application/liquid',
			template: 'proxy/index.liquid.erb',
			layout: false
		})
	end
	
	private
		# store to check against proxy query
		# TODO: break this out into environment variable
		def shared_secret
			Rails.configuration.shopify_secret
		end

		# get query from request.query_string
		# do before all actions
		# store as hash for use throughout controller
		# store reference to shop domain for use throughout controller
		def get_query
			query_string = request.query_string
			@query = Rack::Utils.parse_query(query_string)
			@shop_domain = @query['shop']
			@query
		end

		# validate proxy
		# do before all actions, after get_query
		# parse query signature
		# if invalid, throw exception
		def validate_proxy
			# Remove and save the "signature" entry
			signature = @query.delete("signature")
			sorted_params = @query.collect{ |k, v| "#{k}=#{Array(v).join(',')}" }.sort.join
			
			calculated_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), shared_secret, sorted_params)

			raise 'Invalid signature' if signature != calculated_signature
		end
end
