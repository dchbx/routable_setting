class RoutableSetting::Railtie < Rails::Railtie
  
  rake_tasks do
    load 'routable_setting/tasks/routable_setting.rake'
  end
end