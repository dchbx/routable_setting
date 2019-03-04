module RoutableSetting
  module Sources
    class YamlSource

      attr_accessor :path

      def initialize(path)
        @path = path.to_s
      end

      def load
        result = YAML.load(ERB.new(IO.read(@path)).result) if @path and File.exist?(@path)

        result || {}

        rescue Psych::SyntaxError => e
          raise "YAML syntax error occurred while parsing #{@path}. " \
                "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
                "Error: #{e.message}"
      end

      def routable_key(key)
        [RoutableSetting.setting_prefix, key].join('.')
      end

      def store
        to_dotted_hash(load, ".").each do |key, options|
          RoutableSetting::Setting[routable_key(key)] = options
        end
      end

      def to_dotted_hash(hash, recursive_key = "")
        hash.each_with_object({}) do |(k, v), ret|
          key = recursive_key + k.to_s
          match_str = key.scan(/^\.(.*)/).flatten.first

          if match_str.present?
            key = match_str
          end

          if v.is_a?(Hash) && v.values.any?{|v| v.is_a?(Hash) }
            ret.merge! to_dotted_hash(v, key + ".")
          else
            ret[key] = v
          end
        end
      end
    end
  end
end