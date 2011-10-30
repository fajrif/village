require 'gravtastic'
require 'tilt'
require 'nokogiri'
require 'haml'

class Article
  extend ActiveModel::Naming

  include Gravtastic
  is_gravtastic

  attr_reader :slug, :metadata

  FILENAME_FORMAT = /^(\d+-\d+-\d+)-(.*)(\.[^.]+)$/

  delegate :year, :month, :day, :to => :date

  class Sanitizer < HTML::WhiteListSanitizer; self.allowed_tags -= %w(img a); end

  TagHelper = Class.new.extend ActionView::Helpers::TagHelper

  class << self

    def all
      @@articles ||= Dir.glob(Rails.root + "app/articles/*.{#{Village::Config.file_extensions.join(',')}}").map do |filename|
        Article.new filename
      end.select(&:visible?).sort_by(&:date).reverse
    end

    def tags
      @@tags ||= all.map do |article| 
        article.tags if article.metadata[:tags].present?
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
            article.tags.include?(value) if article.metadata[:tags].present?
          else
            article.send(key) == value
          end
        end
      end
    end

    def find(id)
      where(:to_param => id).first or raise ActionView::MissingTemplate.new(
              ActionController::Base.view_paths, id.inspect, "Invalid article path ID", false)
    end

    def first
      all.first
    end

    def last
      all.last
    end

    def feed
      all.first(10)
    end

    def feed_last_modified
      feed.first.try(:last_modified) || Time.now.utc
    end

    def reset!
      @@articles = nil
      @@tags = nil
    end

    def page_size
      Village::Config.settings.try(:[],:page_size) || 5
    end
  end

  def initialize(path)
    @date_str, @slug, @extension = File.basename(path).match(FILENAME_FORMAT).captures
    load(path)
  end

  def date
    @date ||= Time.zone.parse(metadata[:date] || @date_str).to_date
  end
  
  def email
    if metadata[:author] && metadata[:author][:email]
      metadata[:author][:email]
    end
  end

  def timestamp
    date.to_time_in_current_zone
  end
  alias_method :last_modified, :timestamp

  def visible?
    timestamp <= Time.zone.now
  end

  def content_html
    Tilt[@extension].new { content }.render.html_safe
  end

  def summary_html
    if metadata[:summary].present?
      TagHelper.content_tag :p, summary
    else
      html = Sanitizer.new.sanitize(content_html)
      doc = Nokogiri::HTML.fragment(html)
      para = doc.search('p').detect { |p| p.text.present? }
      para.try(:to_html).try(:html_safe)
    end
  end

  def to_s
    "#{title.inspect} (#{slug})"
  end

  def to_param
    case permalink_format
    when :day   then "%04d/%02d/%02d/%s" % [year, month, day, slug]
    when :month then "%04d/%02d/%s" % [year, month, slug]
    when :year  then "%04d/%s" % [year, slug]
    when :slug  then slug
    end
  end

  def to_key
    [slug]
  end

protected

  def load(path)
    content = File.read(path)
    @metadata = Village::Config.clone(:title, :subtitle, :author, :permalink_format)
    @metadata[:path] = path
    if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
      @metadata.merge! YAML.load($1)
      @metadata[:content] = content[($1.size + $2.size)..-1]
    else
      @metadata[:content] = content
    end
    @metadata = (@metadata || {}).with_indifferent_access
  end

  def method_missing(method, *args)
    if @metadata.include?(method) and !@metadata.nil?
      @metadata[method]
    else
      super
    end
  end

end
