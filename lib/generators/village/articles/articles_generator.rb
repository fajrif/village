require 'generators/base'

module Village
  module Generators
    class ArticlesGenerator < Base
      
      argument :slug, :type => :string, :required => true
      class_option :date, :type => :string, :group => :runtime, :desc => 'Publish date for the article'
      
      def check_slug
        unless slug =~ /^[A-Za-z0-9\-\.]+$/
          puts 'Invalid slug - valid characters include letters, digits and dashes.'
          exit
        end
      end

      def check_date
        if options.date && options.date !~ /^\d{4}-\d{2}-\d{2}$/
          puts 'Invalid date - please use the following format: YYYY-MM-DD, eg. 2011-01-01.'
          exit
        end
      end

      def generate_article
        @date_str, @slug, @extension = File.basename(filename).match(/^(\d+-\d+-\d+)-(.*)(\.[^.]+)$/).captures
        create_file "app/articles/#{@date_str}-#{@slug}#{@extension}" do
          "---\n" +
          "title: #{@slug.titleize}\n" +
          "---\n\n" +
          "CONTENT GOES HERE ..."
        end
      end

  private
      
      def filename
        "#{publish_date}-#{slug.downcase}"
      end
      
      def publish_date
        date = options.date.present? ? Time.zone.parse(options.date) : Time.zone.now
        date.strftime('%Y-%m-%d')
      end
      
    end
  end
end
