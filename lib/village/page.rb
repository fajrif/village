module Village
  class Page < FileModel

    CONTENT_PATH = "app/views/pages"

    self.superclass.create_class_methods_on(Village::Page)

  end
end

