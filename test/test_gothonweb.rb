require_relative '../lib/gothonweb.rb'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class GothonwebTest < Test::Unit::TestCase
	include Rack::Test::Methods


	def app
		Sinatra::Application
	end

	def assert_response(resp, contains=nil, matches=nil, headers=nil, status=200)
		assert_equal(resp.status, status, "Expected response #{status} not in #{resp}")

		if status == 200
			assert(resp.body, "Response data is empty.")
		end

		if contains
			assert((resp.body.include? contains), "Response does not contain #{contains}")
		end

		if matches
			reg = Regexp.new(matches)
			assert reg.match(contains), "Response does not match #{matches}"
		end

		if headers
			assert_equal(resp.headers, headers)
		end
	end

	def test_index
		# check that we get a 404 on the /foo URL
		get("/foo")
		assert_response(last_response, nil, nil, nil, 404)

		# test our first GET request to /, should redirect to /game
		get("/")
		assert_response(last_response, nil, nil, nil, 302)
		follow_redirect!
		assert_match "/game", last_request.url
		assert last_response.ok?

		# test starting corridor
		post("/game", :action => 'shoot!')
		follow_redirect!
		assert_response(last_response, "Death")

		get("/")
		post("/game", :action => 'dodge!')
		follow_redirect!
		puts last_response.body
		assert_response(last_response, "Death")

		
		get "/"
		post "/game", :action => 'tell a joke'
		follow_redirect!
		puts last_response.body
		assert_response(last_response, "Laser Weapon Armory")

		post "/game", :action => '0132'
		follow_redirect!
		assert_response(last_response, "The Bridge")

		post "/game", :action => 'slowly place the bomb'
		follow_redirect!
		assert_response(last_response, "Escape Pod")

		post "/game", :action => '2'
		follow_redirect!
		assert_response(last_response, "You won!")


	end
end