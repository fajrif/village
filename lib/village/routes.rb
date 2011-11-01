class ActionDispatch::Routing::Mapper

  def village(controller,options = {})
    case controller
    when :articles
      options.reverse_merge!({ :as => :articles, :permalink_format => :day })
      get "/#{options[:as]}(.:format)(/tags/:tag)(/:year(/:month(/:day)))" => 'articles#index', :as => :articles, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :tag => /[^\/]+/ }
      get "/#{options[:as]}/*id" => 'articles#show', :as => :article, :constraints => { :id => Village::Config.village_permalink_regex(options) }
    when :pages
      Village::Config.register_template_handler
      match "/#{options[:as]}/*id" => 'pages#show', :as => :page, :format => false
    end
  end

end
