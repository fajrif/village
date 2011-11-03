require 'spec_helper'

describe 'Article views', :type => :request do
  before do
    time_travel_to '2011-05-01'
    Village::Article.reset!
  end

  after { back_to_the_present }

  context 'Articles#index' do
    before { visit village_articles_path }

    it 'should show published articles' do
      # 2011-05-01-full-metadata (published today)
      page.should have_content('Article with full metadata')                # title
      page.should have_content('Posted on 1 May 2011')                      # publish date
      page.should have_content('by John Smith')                             # author
      page.should have_content('This is another custom & test summary.')    # summary

      # 2011-04-28-summary
      page.should have_content('A Test Article')                      # title
      page.should have_content('Posted on 28 April 2011')             # publish date
      page.should have_content('This is a custom & test summary.')    # summary

      # 2011-04-28-image
      page.should have_content('Image')                       # title
      page.should have_content('Posted on 28 April 2011')     # publish date
      page.should have_content('Image description.')          # summary

      # 2011-04-01-first-article
      page.should have_content('Test Village')                  # title
      page.should have_content('Posted on 1 April 2011')        # publish date
      page.should have_content('Lorem ipsum dolor sit amet')    # part of summary
    end

    it 'should not show unpublished articles' do
      # 2015-02-13-custom-title (not published yet)
      page.should_not have_content('this is the next article')      # title
      page.should_not have_content('The next article will ...')     # summary
    end

    it 'should have the correct number of articles that paginated 10 per page' do
      all('section#articles article.village_article').size.should == 10
    end
  end

  context 'Articles#index with no articles' do
    it 'should show a message' do
      time_travel_to '2010-05-01'
      visit village_articles_path(:year => '2010', :month => '05', :day => '01')

      page.should have_content('No articles found.')
      page.should_not have_content('First Article')
    end
  end

  context 'Articles#index with year' do
    before { visit village_articles_path(:year => '2011') }

    it 'should show articles inside the date range' do
      page.should have_content('Article with full metadata')
      page.should have_content('A Test Article')
      page.should have_content('Image')
      page.should have_content('Test Village')
    end
  end

  context 'Articles#index with year and month' do
    before { visit village_articles_path(:year => '2011', :month => '04') }

    it 'should show articles inside the date range' do
      page.should have_content('A Test Article')
      page.should have_content('Image')
      page.should have_content('Test Village')
    end

    it 'should not show articles outside the date range' do
      page.should_not have_content('Article with full metadata')
    end
  end

  context 'Articles#index with year, month and day' do
    before { visit village_articles_path(:year => '2011', :month => '04', :day => '01') }

    it 'should show articles inside the date range' do
      page.should have_content('Test Village')
    end

    it 'should not show articles outside the date range' do
      page.should_not have_content('A Test Article')
      page.should_not have_content('Image')
      page.should_not have_content('Article with full metadata')
    end
  end

  context 'Articles#show' do
    before { visit village_article_path('2011/05/01/full-metadata') }

    it 'should have content' do
      page.should have_content('Article with full metadata')  # title
      page.should have_content('Posted on 1 May 2011')        # publish date
      page.should have_content('by John Smith')               # author

      # body
      page.should have_content('First paragraph of content.')
      page.should have_content('Second paragraph of content.')
    end

    it 'should not show the summary' do
      page.should_not have_content('This is another custom & test summary.')
    end

    it 'should preserve whitespace on code blocks' do
      page.source.should match '<pre><code>First line of code.&#x000A;  Second line of code.&#x000A;</code></pre>'
    end
  end

  context 'Articles#index with rss format' do
    before { visit village_articles_path(:format => :rss) }

    it 'should be rss format type' do
      page.response_headers['Content-Type'].should == 'application/rss+xml; charset=utf-8'
    end

    it 'should be valid rss' do
      lambda do
        Nokogiri::XML::Reader(page.source)
      end.should_not raise_error
    end

    it 'should contain the correct number of items' do
       Nokogiri::XML(page.source).search('item').size.should == 10
    end

    it 'should contain an item that is properly constructed' do
      # pending
      entry = Nokogiri::XML(page.source).search('item').first
      
      entry.search('title').text.should == 'Article with full metadata'
      entry.search('author').first.search('name').text.should == 'John Smith'
      entry.search('pubDate').text.should == '2011-05-01T00:00:00Z'
      entry.search('description').text == "\n      <p>First paragraph of content.</p>\n\n<p>Second paragraph of content.</p>\n\n    "
    end
  end

  context 'Articles#index with atom format' do
      before { visit village_articles_path(:format => :atom) }

      it 'should be atom format type' do
        page.response_headers['Content-Type'].should == 'application/atom+xml; charset=utf-8'
      end

      it 'should be valid atom' do
        lambda do
          Nokogiri::XML::Reader(page.source)
        end.should_not raise_error
      end

      it 'should contain the correct number of entries' do
         Nokogiri::XML(page.source).search('entry').size.should == 10
      end

      it 'should contain an entry that is properly constructed' do
        entry = Nokogiri::XML(page.source).search('entry').first

        entry.search('title').text.should == 'Article with full metadata'
        entry.search('author').first.search('name').text.should == 'John Smith'
        entry.search('author').first.search('email').text.should == 'john.smith@example.com'
        entry.search('published').text.should == '2011-05-01T00:00:00Z'
        entry.search('content').text == "\n      <p>First paragraph of content.</p>\n\n<p>Second paragraph of content.</p>\n\n    "
      end
    end

  context 'Articles#show with invalid slug' do
    it 'should raise missing template' do
      lambda do
        visit village_article_path(:id => '2011/05/01/invalid')
      end.should raise_error(ActionView::MissingTemplate)
    end
  end

end
