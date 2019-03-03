require 'rails/generators/base'
require 'routable_setting'

module RoutableSetting
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Create a MongoDB collection <my_application>_routable_settings to store local settings"

      source_root File.expand_path("../../templates", __FILE__)

      argument :collection_name, type: :string, default: 'routable_settings'

      class_option :setting_prefix, type: :string, default: 'main_app'
      class_option :source_format, type: :string, default: 'yaml'

      def copy_initializer
        template "routable_setting.template", "config/initializers/routable_setting.rb"
      end

      # TODO: improve logic
      def create_mdb_collection
        mongo_settings = "#{Dir.pwd}/config/mongoid.yml"

        unless File.exists?(mongo_settings)
          mongo_settings = (File.expand_path('../../',Dir.pwd) + "/config/mongoid.yml")
        end

        Mongoid.load!(mongo_settings)
        RoutableSetting::Setting.create_mdb_collection({collection_name: collection_name})
      end
    end
  end
end