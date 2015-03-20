require 'jewelpod/config'
require 'jewelpod/version'

module Jewelpod
  def self.config
    @config ||= Config.new
  end
end
