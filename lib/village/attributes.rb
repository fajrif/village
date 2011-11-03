module Village
  module Attributes
    
    attr_accessor :attributes

  private

    def method_missing(method, *args)
      if @attributes.include?(method)
        @attributes[method]
      elsif method =~ /(.*)\=/ and !args.empty?
        @attributes[$1] = args.first
      elsif method =~ /(.*)\?/
        @attributes[$1].present?
      else
        super
      end
    end
    
  end
end