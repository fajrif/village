class ActionDispatch::Routing::Mapper

  def village(controller,options = {})
    Village::Config.initialize_configurations
    case controller
    when :articles
      options.reverse_merge!({ :as => :articles, :permalink_format => :day, :controller => 'village/articles' })
      get "/#{options[:as]}(.:format)(/categories/:category)(/tags/:tag)(/:year(/:month(/:day)))" => "#{options[:controller]}#index", :as => :village_articles, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :tag => /[^\/]+/, :category => /[^\/]+/ }
      get "/#{options[:as]}/*id" => "#{options[:controller]}#show", :as => :village_article, :constraints => { :id => Village::Config.village_permalink_regex(options) }
    when :pages
      options.reverse_merge!({ :as => :pages, :controller => 'village/pages' })
      match "/#{options[:as]}/*id" => "#{options[:controller]}#show", :as => :village_page, :format => false
    end
  end

end
