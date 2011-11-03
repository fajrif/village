require 'yaml'

module Village
  class Config
    extend Village::Attributes

    def self.initialize_configurations(path = "#{Rails.root}/config/village_config.yml")
      if File.exists? path and @attributes.nil?
        @attributes = YAML::load(IO.read(path)).with_indifferent_access
        @attributes.reverse_merge!(default_attributes)
      end
    end

    def self.default_attributes
      { 
        :permalink_regex => 
        { 
          :day => %r[\d{4}/\d{2}/\d{2}/[^/]+],
          :month => %r[\d{4}/\d{2}/[^/]+],
          :year => %r[\d{4}/[^/]+],
          :slug => %r[[^/]+]
          },
        :permalink_format => :day,
        :file_extensions => ["markdown", "erb", "haml"],
        :layout => "village",
        :page_size => 10
        }
    end

    def self.clone(*keys)
      unless @attributes.nil?
        options = @attributes.clone
        options.keep_if { |key,value| keys.include?(key.to_sym) } unless keys.nil?
        options
      else
        {}
      end
    end

    def self.village_permalink_regex(options)
      @attributes[:permalink_format] = options[:permalink_format]
      @attributes[:permalink_regex].try(:[], options[:permalink_format]) or raise_village_permalink_error
    end

private

    def self.raise_village_permalink_error
      possible_options = @attributes[:permalink_regex].map { |k,v| k.inspect }.join(', ')
      raise "Village Routing Error: Invalid :permalink_format option #{attributes[:permalink_format].inspect} - must be one of the following: #{possible_options}"
    end
    
  end
end
