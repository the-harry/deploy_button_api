require 'open3'
require 'sinatra'
require 'sinatra/namespace'

class Server < Sinatra::Application
  namespace '/api/v1' do
    before do
      content_type 'application/json'

      halt(401) if invalid_request?
    end

    post '/deploy' do
      nibble = params[:environment].to_i(2).to_s(16)
      recipe = "./recipes/#{ENV["recipe_#{nibble}"]}"

      stderr = Open3.capture3(recipe)[1]

      if stderr.empty?
        `wall DEPLOY SCHEDULED!`
        status 201
      else
        `wall DEPLOY ERROR: #{stderr}`
        status 500
      end
    end
  end

  private

  def invalid_request?
    return true if request.env['HTTP_USER_AGENT'] != 'ESP8266HTTPClient'

    request.env['HTTP_API_KEY'] != ENV['API_KEY']
  end
end
