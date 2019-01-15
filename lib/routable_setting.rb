require 'mongoid'
require 'routable_setting/version'
require 'routable_setting/setting'
require 'routable_setting/options'
require 'routable_setting/sources/hash_source'
require 'routable_setting/caches/setting_cache'

module RoutableSetting

  mattr_accessor :const_name, :db_collection

  def self.configure
    yield(self)
  end

  def self.import_settings(settings)
    config = RoutableSetting::Options.new
    config.add_source!(settings)
    config.load!
  end

  class Error < StandardError; end
end




