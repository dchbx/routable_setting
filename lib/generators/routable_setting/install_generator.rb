require 'rails/generators/base'
require 'routable_setting'

module RoutableSetting
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Create a MongoDB collection <my_application>_routable_settings to store local settings"

      source_root File.expand_path('../../templates', __FILE__)

      class_option :source_format,   type: :string, default: 'yaml'
      class_option :setting_prefix,  type: :string, default: 'main_app'
      class_option :collection_name, type: :string, default: 'routable_settings'

      def copy_initializer
        template 'routable_setting.template', RoutableSetting::CONFIG_PATH
      end
    end
  end
end