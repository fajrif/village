class ActionDispatch::Routing::Mapper

  def village(controller,options = {})
    case controller
    when :articles
      options.reverse_merge!({ :as => :articles, :permalink_format => :day })
      get "/#{options[:as]}(.:format)(/tags/:tag)(/:year(/:month(/:day)))" => 'articles#index', :as => :articles, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :tag => /[^\/]+/ }
      get "/#{options[:as]}/*id" => 'articles#show', :as => :article, :constraints => { :id => village_permalink_regex(options) }
    when :pages
      match "/#{options[:as]}/*path" => 'pages#show', :as => :page, :format => false
    end
  end

private

  def village_permalink_regex(options)
    Village::Config.settings[:permalink_format] = options[:permalink_format]
    Village::Config.settings[:permalink_regex].try(:[], options[:permalink_format]) or raise_village_permalink_error
  end

  def raise_village_permalink_error
    possible_options = Village::Config.permalink_regex.map { |k,v| k.inspect }.join(', ')
    raise "Village Routing Error: Invalid :permalink_format option #{Village::Config.permalink_format.inspect} - must be one of the following: #{possible_options}"
  end
end
