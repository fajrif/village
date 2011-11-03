require 'gravtastic'
require 'nokogiri'

module Village
  class Article < FileModel
    include Gravtastic
    is_gravtastic

    CONTENT_PATH = "app/articles"

    delegate :year, :month, :day, :to => :date

    class Sanitizer < HTML::WhiteListSanitizer; self.allowed_tags -= %w(img a); end

    TagHelper = Class.new.extend ActionView::Helpers::TagHelper

    self.superclass.create_class_methods_on(Village::Article)
    
    class << self
      def order
        all.select(&:visible?).sort_by(&:date).reverse
      end

      def tags
        @@tags ||= all.map do |article| 
          article.tags if article.attributes[:tags].present?
        end.compact.flatten.inject(Hash.new(0)) do |h,e| 
          h[e] += 1; h
        end.inject({}) do |r, e| 
          r[e.first] = e.last; r
        end
      end

      def where(conditions = {})
        conditions = conditions.symbolize_keys
        conditions.assert_valid_keys :year, :month, :day, :slug, :to_param, :tag
        [:year, :month, :day].each do |key|
          conditions[key] = conditions[key].to_i if conditions[key].present?
        end
        all.select do |article|
          conditions.all? do |key, value| 
            case key
            when :tag
              article.tags.include?(value) if article.attributes[:tags].present?
            else
              article.send(key) == value
            end
          end
        end
      end

      def feed
        all.first(Village::Config.page_size)
      end

      def feed_last_modified
        feed.first.try(:last_modified) || Time.now.utc
      end

      def reset!
        @@files = nil
        @@tags = nil
      end
    end

    def initialize(path)
      super path
      attributes[:permalink_format] = Village::Config.permalink_format
      @date_str, @slug = File.basename(path).match(/^(\d+-\d+-\d+)-(.*)(\.[^.]+)$/).captures
    end

    def date
      @date ||= Time.zone.parse(attributes[:date] || @date_str).to_date
    end

    def email
      if attributes[:author] && attributes[:author][:email]
        attributes[:author][:email]
      end
    end

    def timestamp
      date.to_time_in_current_zone
    end
    alias_method :last_modified, :timestamp

    def visible?
      timestamp <= Time.zone.now
    end

    def summary_html
      if attributes[:summary].present?
        TagHelper.content_tag :p, summary
      else
        html = Sanitizer.new.sanitize(content_html)
        doc = Nokogiri::HTML.fragment(html)
        para = doc.search('p').detect { |p| p.text.present? }
        para.try(:to_html).try(:html_safe)
      end
    end

    def to_param
      case attributes[:permalink_format]
      when :day   then "%04d/%02d/%02d/%s" % [year, month, day, slug]
      when :month then "%04d/%02d/%s" % [year, month, slug]
      when :year  then "%04d/%s" % [year, slug]
      when :slug  then slug
      end
    end

  end
end
