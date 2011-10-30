require 'tilt'

class Page < ActionView::Template::Handler
  include ActionView::Template::Handlers::Compilable
  
  def compile(template)
    Tilt[template.inspect].new(template.inspect).render.inspect
  end
end
