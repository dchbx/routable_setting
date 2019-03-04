require 'mongoid'
require 'routable_setting/version'
require "routable_setting/railtie" if defined?(Rails)
require 'routable_setting/setting'
require 'routable_setting/options'
require 'routable_setting/sources/yaml_source'
require 'routable_setting/sources/hash_source'
require 'routable_setting/sources/db_source'
require 'routable_setting/caches/setting_cache'
require 'deep_merge'

module RoutableSetting

  CONFIG_PATH = "/config/initializers/routable_setting.rb" 

  mattr_accessor :const_name, :db_collection, :setting_prefix, :source_format

  @@const_name = 'RoutableSettings'

  class << self

    def configure
      yield(self)
    end

    def store_settings!(files)
      options = Options.new

      files.each do |file|
        if source_format.to_sym == :yaml
          options.add_source!(file.to_s)
        else
          require file
          options.add_source!(CONFIGURATIONS)
        end
      end

      options.store!
    end

    def load_settings  
      options = Options.new
      routable_engines.each  do |engine| 
        options.add_source!(engine)
      end
      options.load!
      set_environment_const(options)
    end

    def set_environment_const(options)
      Kernel.send(:remove_const, RoutableSetting.const_name) if Kernel.const_defined?(RoutableSetting.const_name)
      Kernel.const_set(RoutableSetting.const_name, options)
    end

    def routable_engines
      [Rails] + Rails::Engine.subclasses.select do |engine|
        File.exists?(engine.root.to_s + CONFIG_PATH)
      end
    end
  end

  class Error < StandardError; end
end