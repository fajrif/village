xml.instruct!
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title Village::Config.title
  xml.link articles_url(:format => :atom)
  xml.id articles_url
  xml.updated Article.feed_last_modified.xmlschema

  Article.feed.each do |article|
    xml.entry do
      xml.title article.title, :type => :text
      xml.link :href => article_url(article), :rel => :alternate, :type => 'text/html'
      xml.published article.timestamp.xmlschema
      xml.updated article.last_modified.xmlschema
      if article.metadata[:author].present?
        xml.author do
          xml.name article.author[:name]
          xml.email article.author[:email]
        end
      end
      xml.id article_url(article)
      xml.content :type => :html, 'xml:base' => article_url(article) do
        xml.cdata! article.content_html
      end
    end
  end
end
