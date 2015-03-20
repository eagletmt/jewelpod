module Jewelpod
  class Config
    attr_accessor :storage_url

    DEFAULT_STORAGE_URL = 'file:///var/lib/jewelpod'

    def initialize
      @storage_url = DEFAULT_STORAGE_URL
    end
  end
end
