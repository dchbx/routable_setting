namespace :routable_setting do

  task :import_settings, :routable_engines do |t, args|
    args.routable_engines.each do |engine|

      require File.expand_path(engine.root.to_s + RoutableSetting::CONFIG_PATH)

      puts "*"*80 unless Rails.env.test?
      puts "::: Loading Configurations :::"

      files = if RoutableSetting.source_format.to_sym == :yaml
        Dir.glob(engine.root.to_s + '/db/seedfiles/configurations/*.yml')
      else
        Dir.glob(engine.root.to_s + '/db/seedfiles/configurations/*.rb')
      end

      RoutableSetting.store_settings!(files)

      puts "::: Configurations Complete :::"
      puts "*"*80 unless Rails.env.test?
    end
  end

  task :import => :environment do
    Rake::Task["routable_setting:import_settings"].invoke(RoutableSetting.routable_engines)
  end
end