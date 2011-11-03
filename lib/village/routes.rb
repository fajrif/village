class ActionDispatch::Routing::Mapper

  def village(controller,options = {})
    Village::Config.initialize_configurations
    case controller
    when :articles
      options.reverse_merge!({ :as => :articles, :permalink_format => :day })
      get "/#{options[:as]}(.:format)(/categories/:category)(/tags/:tag)(/:year(/:month(/:day)))" => 'village/articles#index', :as => :village_articles, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :tag => /[^\/]+/, :category => /[^\/]+/ }
      get "/#{options[:as]}/*id" => 'village/articles#show', :as => :village_article, :constraints => { :id => Village::Config.village_permalink_regex(options) }
    when :pages
      match "/#{options[:as]}/*id" => 'village/pages#show', :as => :village_page, :format => false
    end
  end

end
