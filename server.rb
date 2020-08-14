require 'sinatra'
require "sinatra/namespace"

class Server < Sinatra::Application
  namespace '/api/v1' do
    post '/deploy' do
      `echo DEPLOY`
      `wall DEPLOY SCHEDULED!`

      status 201
    end
  end
end
