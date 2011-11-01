require 'yaml'

module Village
  class Config

    def self.load(path = "#{Rails.root}/config/village_config.yml")
      raise_village_configuration_error("Unable to locate configuration file: #{path}") unless File.exists? path
      Config.settings ||= YAML::load(IO.read(path)).with_indifferent_access
      Config.settings.reverse_merge!(default_settings)
    end

    class << self
      attr_accessor :settings
      alias_method :initialize_configuration_settings, :load
    end

    def self.register_template_handler
      default_handlers.each do |ext|
        ActionView::Template.register_template_handler ext, Page
      end
    end

    def self.default_settings
      { 
        :permalink_regex => 
        { 
          :day => %r[\d{4}/\d{2}/\d{2}/[^/]+],
          :month => %r[\d{4}/\d{2}/[^/]+],
          :year => %r[\d{4}/[^/]+],
          :slug => %r[[^/]+]
          },
        :permalink_format => :day,
        :file_extensions => ["markdown", "textile", "erb", "haml"]
        }
    end

    def self.default_handlers
      require 'action_controller/base'
      settings[:file_extensions] - ActionView::Template.template_handler_extensions unless settings.nil?
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

    def self.village_permalink_regex(options)
      settings[:permalink_format] = options[:permalink_format]
      settings[:permalink_regex].try(:[], options[:permalink_format]) or raise_village_permalink_error
    end

private

    def self.raise_village_permalink_error
      possible_options = settings[:permalink_regex].map { |k,v| k.inspect }.join(', ')
      raise "Village Routing Error: Invalid :permalink_format option #{settings[:permalink_format].inspect} - must be one of the following: #{possible_options}"
    end

    def self.raise_village_configuration_error(message)
      raise "Village Configuration Error: #{message}"
    end

    def self.method_missing(method, *args)
      if settings.include?(method) and !settings.nil?
        settings[method]
      else
        super
      end
    end
  end
end
