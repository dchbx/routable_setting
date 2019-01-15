require 'mongoid'

module RoutableSetting
  class Setting

    include Mongoid::Document
    include Mongoid::Timestamps

    field :label,       type: String  # fill using key like i18n in the form if not provided
    field :description, type: String

    field :key,         type: String  # benefit_markets.shop_market.initial_application
    field :value,       type: String
    field :default,     type: String, default: ''

    field :type,        type: String # list, date, number, boolean, string, range, datetime, day of month, days, year, months
    field :is_required, type: Boolean, default: true

    # list/enumerated...capture if user can choose multiple
    scope :get_all,  -> (starting_with) {
      where(key: /^#{::Regexp.escape(starting_with)}/i)
    }

    scope :by_key, -> (key) { 
      where(key: key)
    }

    index({ key: 1 }, { unique: true })

    validates_presence_of   :default, :is_required
    validates_uniqueness_of :key

    def value=(val)
      write_attribute(:value, serialize_value(val))
    end

    def default=(val)
      write_attribute(:default, serialize_value(val))
    end

    def serialize_value(val)
      return nil if val.blank?

      if val.to_s.scan(/<%/).present?
        ERB.new(val).src
      else
        val.inspect
      end
    end

    class << self

      def [](key)
        setting_cache.fetch(key)
      end

      def []=(key, attrs)
        find_or_initialize_setting(key).tap do |setting|
          setting.attributes = attrs
          setting.with(collection: RoutableSetting.db_collection).save!
          setting_cache.write(setting)
        end
      end

      def find_or_initialize_setting(key)
        find_setting(key) || new(key: key)
      end

      def find_setting(key)
        with(collection: RoutableSetting.db_collection).by_key(key).first
      end

      def setting_cache
        Caches::SettingCache.new(self)
      end

      def create_mdb_collection(options)
        collection_name = options["collection_name"]

        begin
          db = Mongoid.default_client.database
        rescue Mongoid::Errors::NoClientsConfig
          Mongoid.load!('config/mongoid.yml')
          retry
        end

        if db.collection_names.exclude?(collection_name)
          db.command(:eval => "db.createCollection('#{collection_name}')")
        end
      end
    end
  end
end
