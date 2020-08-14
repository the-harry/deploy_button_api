require 'open3'
require 'sinatra'
require 'sinatra/namespace'

class Server < Sinatra::Application
  COMMAND = 'echo DEPLOY'

  namespace '/api/v1' do
    post '/deploy' do
      stderr = Open3.capture3(COMMAND)[1]

      if stderr.empty?
        `wall DEPLOY SCHEDULED!`
        status 201
      else
        `wall DEPLOY ERROR: #{stderr}`
        status 500
      end
    end
  end
end
