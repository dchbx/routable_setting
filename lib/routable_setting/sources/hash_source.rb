module RoutableSetting
  module Sources
    class HashSource

      def initialize(hash)
        @hash = hash
      end

      def load
        @hash.each do |key, options|
          RoutableSetting::Setting[key] = options
        end
      end
    end
  end
end