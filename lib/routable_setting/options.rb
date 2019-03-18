module RoutableSetting
  class Options < OpenStruct

    def add_source!(source)
      if source.is_a?(Hash)
        source = RoutableSetting::Sources::HashSource.new(source)
      elsif source.is_a?(String)
        source = RoutableSetting::Sources::YamlSource.new(source)
      else
        source = RoutableSetting::Sources::DbSource.new(source)
      end

      @config_sources ||= []
      @config_sources << source
    end

    def store!
      @config_sources.each do |source|
        source.store
      end
    end

    # look through all our sources and rebuild the configuration
    def reload!
      conf = {}
      @config_sources.each do |source|
        source_conf = source.load

        if conf.empty?
          conf = source_conf
        else
          DeepMerge.deep_merge!(
                                source_conf,
                                conf,
                                preserve_unmergeables: false,
                                knockout_prefix:       nil,
                                overwrite_arrays:      true,
                                merge_nil_values:      true
                               )
        end
      end

      # swap out the contents of the OStruct with a hash (need to recursively convert)
      marshal_load(__convert(conf).marshal_dump)
      
      self
    end

    alias :load! :reload!

    def __convert(h) #:nodoc:
      s = self.class.new

      h.each do |k, v|
        k = k.to_s if !k.respond_to?(:to_sym) && k.respond_to?(:to_s)
        s.new_ostruct_member(k)

        if v.is_a?(Hash)
          v = v["type"] == "hash" ? v["contents"] : __convert(v)
        elsif v.is_a?(Array)
          v = v.collect { |e| e.instance_of?(Hash) ? __convert(e) : e }
        end

        value = if v.is_a?(RoutableSetting::Options)
          v
        else
          eval(v)
        end

        s.send("#{k}=".to_sym, value)
      end
      s
    end
  end
end