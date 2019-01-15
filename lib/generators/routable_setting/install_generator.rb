require 'rails/generators/base'
require 'routable_setting'

module RoutableSetting
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Create a MongoDB collection <my_application>_routable_settings to store local settings"

      source_root File.expand_path("../../templates", __FILE__)

      argument :collection_name, type: :string, default: 'routable_settings'
      class_option :collection_name, type: :string, default: 'routable_settings'

      def copy_initializer
        self.collection_name = options["collection_name"]
        template "routable_setting.template", "config/initializers/routable_setting.rb"
      end

      def create_mdb_collection
        RoutableSetting::Setting.create_mdb_collection(options)
      end
    end
  end
end