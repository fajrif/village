require 'tilt'

class Page
  def self.call(template)
    Tilt[template.inspect].new(template.inspect).render.inspect
  end
end
