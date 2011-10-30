require 'yaml'

module Village
  class Config
    
    class << self
      attr_accessor :settings
    end
    
    def self.load(path = "#{Rails.root}/config/village_config.yml")
      Config.settings ||= YAML::load(IO.read(path)).with_indifferent_access
    end
    
    def self.clone(*keys)
      unless settings.nil?
        options = settings.clone
        options.keep_if { |key,value| keys.include?(key.to_sym) } unless keys.nil?
        options
      else
        {}
      end
    end
    
protected
    def self.method_missing(method, *args)
      if settings.include?(method) and !settings.nil?
        settings[method]
      else
        super
      end
    end
    
  end
end
