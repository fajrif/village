if File.exists? "#{Rails.root}/config/village_config.yml"
  Village::Config.load
  Village::Config.settings[:permalink_regex] = {}
  Village::Config.settings[:permalink_format] = :day
  Village::Config.settings[:permalink_regex][:day]   = %r[\d{4}/\d{2}/\d{2}/[^/]+]
  Village::Config.settings[:permalink_regex][:month] = %r[\d{4}/\d{2}/[^/]+]
  Village::Config.settings[:permalink_regex][:year]  = %r[\d{4}/[^/]+]
  Village::Config.settings[:permalink_regex][:slug]  = %r[[^/]+]
  Village::Config.settings[:file_extensions] = [ :erb, :rhtml, :erubis, :haml, :builder, :liquid,
                                                :markdown, :mkd, :md, :textile, :rdoc, :radius, :mab,
                                                :wiki, :mediawiki, :mw, :creole, :yajl ]
end

[ :liquid, :markdown, :mkd, :md, :textile, :rdoc, :radius, :mab, :wiki, :mediawiki, :mw, :creole, :yajl ].each do |ext|
  ActionView::Template.register_template_handler ext, Page
end
