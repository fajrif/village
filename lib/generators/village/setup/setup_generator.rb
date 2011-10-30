require 'generators/base'

module Village
  module Generators
    class SetupGenerator < Base #:nodoc: 
      
      class_option :pages, :desc => 'Setup village:pages for static pages', :type => :boolean, :default => true
      class_option :articles, :desc => 'Setup village:articles for blog engine', :type => :boolean, :default => true
      
      def setup
        gem "redcarpet"
        refresh_bundle
        template 'village_config.yml', 'config/village_config.yml'
        copy_file 'init_village.rb', 'config/initializers/init_village.rb'
        setup_pages if options.pages
        setup_articles if options.articles
      rescue Exception => e
        print_notes(e.message,"error",:red)
      end
      
  private
      def setup_pages
        asking "would you like to setup village:pages for static page?" do
          `mkdir app/views/pages`
          route "village :pages"
          copy_file 'example-page.markdown', 'app/views/pages/example-page.markdown'
        end
      end
      
      def setup_articles
        asking "would you like to setup village:articles for blog engine?" do
          `mkdir app/articles`
          directory "views/articles", "app/views/articles/", :recursive => true
          copy_file '2001-01-01-example-article.markdown', 'app/articles/2001-01-01-example-article.markdown'
          route "village :articles"
          gem "kaminari"
          refresh_bundle
          copy_file 'views/layout.html.haml', 'app/views/layouts/layout.html.haml'
          copy_asset 'views/village.css', 'public/stylesheets/village.css'
          print_notes "please edit layout settings in config/village_config.yml to use the new layout!"
        end
      end
      
    end
  end
end
