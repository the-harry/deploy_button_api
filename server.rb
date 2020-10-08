require 'open3'
require 'sinatra'
require 'sinatra/namespace'
require 'json'

class Server < Sinatra::Application
  namespace '/api/v1' do
    before do
      content_type 'application/json'
      return_unauthorized if invalid_request?

      request.body.rewind
      params = JSON.parse(request.body.read, symbolize_names: true)

      @nibble = params[:environment].to_i(2).to_s(16)
    end

    post '/deploy' do
      recipe_name = ENV["RECIPE_#{@nibble}"]
      recipe = "#{__dir__}/recipes/#{recipe_name}"

      stderr = Open3.capture3(recipe)[1]

      stderr.empty? ? return_success(recipe_name) : return_failure(stderr)
    end
  end

  private

  def invalid_request?
    return true if request.env['HTTP_USER_AGENT'] != 'ESP8266HTTPClient'

    request.env['HTTP_API_KEY'] != ENV['API_KEY']
  end

  def return_unauthorized
    `wall WARNING, INTRUDER REQUEST FROM #{request.ip} 0o`
    halt(401)
  end

  def return_success(recipe)
    `wall DEPLOY SCHEDULED TO RECIPE: #{recipe}`
    status 201
  end

  def return_failure(error)
    `wall DEPLOY ERROR: #{error}`
    status 500
  end
end
