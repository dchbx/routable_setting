module RoutableSetting
  module Caches
    class SettingCache

      class << self

        def load!
          options = RoutableSetting.load_settings
          write(options: options)
          RoutableSetting.set_dynamic_finders(options)
        end

        def fetch(key: nil, options:)
          Rails.cache.fetch(cache_key(key)) do
            options
          end
        end

        def write(key: nil, options:)
          Rails.cache.write(cache_key(key), options)
        end

        def cache_key(key = nil)
          [RoutableSetting.to_s.underscore, key].join("_")
        end
      end
    end

    #   def parse_value(setting)
    #     value_parser = proc {|value|
    #       $SAFE = 2
    #       eval(value)
    #     }

    #     value_parser.call(setting.value || setting.default)
    #   end
    # end
  end
end