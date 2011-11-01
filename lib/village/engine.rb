module Village
  class Engine < ::Rails::Engine
    initializer 'village.init_config' do
      Village::Config.initialize_configuration_settings
    end
  end
end
