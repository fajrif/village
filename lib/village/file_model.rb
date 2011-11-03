require 'tilt'

module Village
  class FileModel
    extend ActiveModel::Naming
    include Village::Attributes

    attr_accessor :content_path, :to_param, :folders, :slug, :extension

    def initialize(path)
      @content_path, @to_param, @folders, @slug, @extension = path.match(/^#{Rails.root}\/(#{self.class::CONTENT_PATH})\/((.*\/)?(.*))(\.[^.]+)$/).captures
      content = File.read(path)
      @attributes = Village::Config.clone(:title, :subtitle, :author, :layout)
      if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        @attributes.merge! YAML.load($1)
        @attributes[:content] = content[($1.size + $2.size)..-1]
      else
        @attributes[:content] = content
      end
      @attributes = (@attributes || {}).with_indifferent_access
    end

    def self.create_class_methods_on(klass)
      klass.instance_eval do
        def all
         @@files ||= Dir.glob("#{Rails.root}/#{self::CONTENT_PATH}/**/*.{#{Village::Config.file_extensions.join(',')}}").map do |filename|
            new filename
          end
        end
        
        def where(conditions = {})
          conditions = conditions.symbolize_keys
          conditions.assert_valid_keys :to_param
          all.select do |article|
            conditions.all? do |key, value| 
              article.send(key) == value
            end
          end
        end
        
        def find(id)
          where(:to_param => id).first or raise_missing_template(id.inspect)
        end
        
        def first
          all.first
        end
      
        def last
          all.last
        end
      
        def reset!
          @@files = nil
        end
        
        private
        def raise_missing_template(id)
          if Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR >= 1
            raise ActionView::MissingTemplate.new(
                    [self::CONTENT_PATH], id, "Invalid ID", false, ActionView::Template.template_handler_extensions)
          else
            raise ActionView::MissingTemplate.new(
                    [self::CONTENT_PATH], id, "Invalid ID", false)
          end
        end
      end # end child.instance_eval
    end # end self.create_class_methods_on

    def content_html
      Tilt[@extension].new { @attributes[:content] }.render.html_safe if @attributes[:content].present?
    end
    
    def to_s
      "#{@attributes[:title]} (#{@to_param})"
    end
    
    def to_key
      [@to_param]
    end

  end
end
