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

  CONFIG_PATH = '/config/initializers/routable_setting.rb'
  mattr_accessor :const_name, :db_collection, :setting_prefix, :source_format

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
    end

    def set_dynamic_finders(options)
      options.to_h.keys.each do |key|
        define_singleton_method :"#{key}" do
          RoutableSetting::Caches::SettingCache.fetch(key: key, options: options.send(key))
        end
      end
    end

    def routable_engines
      [Rails] + Rails::Engine.subclasses.select do |engine|
        File.exists?(engine.root.to_s + CONFIG_PATH)
      end
    end

    def cache_key(key)
      [self.to_s.underscore, key.to_s].join('_')
    end
  end

  class Error < StandardError; end
end