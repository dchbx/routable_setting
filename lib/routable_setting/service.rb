module RoutableSetting
  class Service
    include Mongoid::Document
    include Mongoid::Timestamps

    field :const_name,  type: String  # BenefitMarket, BenefitSponsor
    field :collection_name, type: Boolean, default: false
    field :enabled,  type: Boolean, default: true

  end
end