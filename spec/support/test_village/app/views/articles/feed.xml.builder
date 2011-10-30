xml.instruct!
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title Village::Config.title
  xml.link :href => articles_feed_url, :rel => :self, :type => 'application/atom+xml'
  xml.link :href => articles_url, :rel => :alternate, :type => 'text/html'
  xml.id articles_url
  xml.updated Article.feed_last_modified.xmlschema

  Article.feed.each do |article|
    xml.entry do
      xml.title article.title, :type => :text
      xml.link :href => article_url(article), :rel => :alternate, :type => 'text/html'
      xml.published article.timestamp.xmlschema
      xml.updated article.last_modified.xmlschema

      if article.author.present?
        xml.author do
          xml.name article.author[:name]
          xml.email article.author[:email] if article.author[:email].present?
        end
      end

      xml.id article_url(article)
      xml.content :type => :html, 'xml:base' => article_url(article) do
        xml.cdata! article.content_html
      end
    end
  end
end
