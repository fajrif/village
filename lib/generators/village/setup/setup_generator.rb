require 'generators/base'

module Village
  module Generators
    class SetupGenerator < Base #:nodoc: 
      
      class_option :pages, :desc => 'Setup village:pages for static pages', :type => :boolean, :default => true
      class_option :articles, :desc => 'Setup village:articles for blog engine', :type => :boolean, :default => true
      
      def setup
        template 'village_config.yml', 'config/village_config.yml'
        gem "haml-rails"
        refresh_bundle
        setup_pages if options.pages
        setup_articles if options.articles
        setup_markdown
      rescue Exception => e
        print_notes(e.message,"error",:red)
      end
      
  private
      def setup_pages
        asking "would you like to setup village:pages for static page?" do
          empty_directory "app/views/pages"
          route "village :pages"
          copy_file 'example-page.markdown', 'app/views/pages/example-page.markdown'
          asking "would you to copy village:pages views application directory?" do
            empty_directory "app/views/village/pages/"
            directory "views/pages", "app/views/village/pages/", :recursive => true
            copy_file 'views/village.html.haml', 'app/views/layouts/village.html.haml', :force => true
          end
        end
      end
      
      def setup_articles
        asking "would you like to setup village:articles for blog engine?" do
          empty_directory "app/views/articles"
          copy_asset 'views/village.css', 'public/stylesheets/village.css'
          print_notes "copied default village stylesheets.css you can change it later!"
          copy_file '2001-01-01-example-article.markdown', 'app/views/articles/2001-01-01-example-article.markdown'
          route "village :articles"
          gem "kaminari"
          refresh_bundle
          asking "would you to copy village:articles views directory?" do
            empty_directory "app/views/village/articles/"
            directory "views/articles", "app/views/village/articles/", :recursive => true
            copy_file 'views/village.html.haml', 'app/views/layouts/village.html.haml', :force => true
          end
        end
      end
      
      def setup_markdown
        markdown = ["RDiscount", "Redcarpet", "BlueCloth", "Kramdown", "Maruku"]
        unless check_some_gems?(*markdown.map { |m| m.downcase })
          puts "Please choose markdown engine you wish to use:"
          markdown.each_with_index { |value,index| puts "#{index+1}.#{value}" }
          mkd = ask(">")
          markdown.each_with_index do |value,index| 
            gem "#{value.downcase}" if (index + 1) == mkd.to_i
          end
          refresh_bundle
        end
      end
      
    end
  end
end
