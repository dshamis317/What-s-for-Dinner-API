require 'bundler'
Bundler.require

require_relative 'models/search'

yelp_client = Yelp::Client.new({ 
	consumer_key: ENV['YELP_CONSUMER_KEY'],
	consumer_secret: ENV['YELP_CONSUMER_SECRET'],
	token: ENV['YELP_TOKEN'],
	token_secret: ENV['YELP_TOKEN_SECRET']
	})

get '/' do
	'Hello World'
end

get '/wfd/search' do
	q = params[:q] if params[:q]
	lat = params[:lat] if params[:lat]
	long = params[:long] if params[:long]
	location = params[:location].gsub('%20',' ') if params[:location]
	offset = params[:offset] ? params[:offset] : 0

	params = {
		term: q,
		limit: 5,
		offset: offset
	}

	locale = {
		'lang' => 'en'
	}

	if !lat.nil? && !long.nil?
		yelp_client.search_by_coordinates({latitude: lat,longitude: long}, params, locale).to_json
	elsif !location.nil?
		yelp_client.search(location, params).to_json
	else
		status 403
    	{error: 403, message: 'There was no location information provided. Please allow for location sharing or enter an address.'}.to_json
    end
end