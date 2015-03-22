require 'sinatra/base'
require 'jewelpod'
require 'jewelpod/storage'

module Jewelpod
  class Server < Sinatra::Base
    post '/upload' do
      storage = Storage.find(Jewelpod.config.storage_url)
      storage.store(params[:file])
      redirect '/'
    end

    get '/api/v1/dependencies' do
      gems = (params[:gems] || '').split(',')
      if gems.empty?
        200
      else
        storage = Storage.find(Jewelpod.config.storage_url)
        Marshal.dump(storage.get_dependencies(gems))
      end
    end

    get '/*' do
      storage = Storage.find(Jewelpod.config.storage_url)
      storage.serve(env)
    end
  end
end

if defined?(Bundler)
  Gem.post_reset do
    Gem::Specification.all = nil
  end
end
