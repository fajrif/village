module Village
  
  autoload :Attributes, 'village/attributes'
  autoload :Config, 'village/config'
  autoload :FileModel, 'village/file_model'
  autoload :Article, 'village/article'
  autoload :Page, 'village/page'
  
  class Engine < ::Rails::Engine
  end
end
