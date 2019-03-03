namespace :routable_setting do

  task :import_settings, :routable_engines do |t, args|
    args.routable_engines.each do |engine|

      require File.expand_path(engine.root.to_s + RoutableSetting::CONFIG_PATH)

      Dir.glob(engine.root.to_s + '/db/seedfiles/configurations/*').each do |file|
        require file
      end

      puts "*"*80 unless Rails.env.test?
      puts "::: Generating Configurations :::"

      configurations = [IVL_CONFIGURATIONS, SHOP_CONFIGURATIONS].reduce({}, :merge)

      unless Rails.env.test?
        p configurations
      end

      RoutableSetting.import_settings(configurations)

      IVL_CONFIGURATIONS  = {}
      SHOP_CONFIGURATIONS = {}

      puts "::: Configurations Complete :::"
      puts "*"*80 unless Rails.env.test?
    end
  end

  task :import => :environment do
    Rake::Task["routable_setting:import_settings"].invoke(RoutableSetting.routable_engines)
  end
end