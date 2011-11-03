xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title Village::Config.title
    xml.description Village::Config.subtitle
    xml.link articles_url(:format => :rss)
    xml.generator articles_url(:format => :rss)
    xml.lastBuildDate Village::Article.feed_last_modified
    
    for article in Village::Article.feed
      xml.item do
        xml.title article.title
        xml.description :type => :html, 'xml:base' => article_url(article) do
          xml.cdata! article.summary_html
        end
        xml.pubDate article.timestamp.xmlschema
        xml.link :href => article_url(article), :rel => :alternate, :type => 'text/html'
        xml.guid article_url(article)
        if article.author.present?
          xml.author do
            xml.name article.author[:name]
            xml.email article.author[:email]
          end
        end
        if article.tags?
          xml.category article.tags.join(",")
        end
      end
    end
  end
end
