module RoutableSetting
  class Options

    def add_source!(source)
      source = Sources::HashSource.new(source) if source.is_a?(Hash)

      @config_sources ||= []
      @config_sources << source
    end

    def load!
      @config_sources.each do |source|
        source.load
      end
    end
  end
end