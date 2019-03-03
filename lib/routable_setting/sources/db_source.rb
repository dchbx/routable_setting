module RoutableSetting
  module Sources
    class DbSource

      def initialize(component)
        @component = component
      end

      def load
        require File.expand_path(@component.root.to_s + RoutableSetting::CONFIG_PATH)

        setting_hash = {}

        RoutableSetting::Setting.find_all.each do |setting|
          if setting_hash.empty?
            setting_hash = setting.to_nested_hash
          end
          DeepMerge.deep_merge!(setting.to_nested_hash, setting_hash)
        end

        setting_hash
      end
    end
  end
end