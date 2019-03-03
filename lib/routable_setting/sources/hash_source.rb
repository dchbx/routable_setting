module RoutableSetting
  module Sources
    class HashSource

      def initialize(hash)
        @hash = hash
      end

      def routable_key(key)
        [RoutableSetting.setting_prefix, key].join('.')
      end

      def store
        @hash.each do |key, options|
          RoutableSetting::Setting[routable_key(key)] = options
        end
      end
    end
  end
end