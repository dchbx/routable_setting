require 'routable_setting/version'
require 'mongoid'
require 'routable_setting/options'
require 'routable_setting/sources/hash_source'
require 'routable_setting/caches/setting_cache'

module RoutableSetting

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield(configuration)
  end

  class Configuration
    attr_accessor :db_collection

    def initialize
      @db_collection = 'routable_settings'
    end
  end

  class Error < StandardError; end
end

RoutableSetting.configure do |config|
  config.db_collection = "routable_settings"
end

require 'routable_setting/setting'
   
