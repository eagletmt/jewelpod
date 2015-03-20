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

    get '/*' do
      storage = Storage.find(Jewelpod.config.storage_url)
      storage.serve(env)
    end
  end
end
  end
end
