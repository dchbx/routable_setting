class RoutableSetting::Railtie < Rails::Railtie
  
  rake_tasks do
    load 'routable_setting/tasks/routable_setting.rake'
  end

  initializer "routable_setting.rotable_setting_cache" do
    RoutableSetting::Caches::SettingCache.load!
  end
end