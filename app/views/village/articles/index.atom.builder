xml.instruct!
xml.feed :xmlns => 'http://www.w3.org/2005/Atom' do
  xml.title Village::Config.title
  xml.link village_articles_url(:format => :atom)
  xml.id village_articles_url
  xml.updated Village::Article.feed_last_modified.xmlschema

  Village::Article.feed.each do |article|
    xml.entry do
      xml.title article.title, :type => :text
      xml.link :href => village_article_url(article), :rel => :alternate, :type => 'text/html'
      xml.published article.timestamp.xmlschema
      xml.updated article.last_modified.xmlschema
      if article.author?
        xml.author do
          xml.name article.author[:name]
          xml.email article.author[:email]
        end
      end
      xml.id village_article_url(article)
      xml.content :type => :html, 'xml:base' => village_article_url(article) do
        xml.cdata! article.content_html
      end
    end
  end
end
