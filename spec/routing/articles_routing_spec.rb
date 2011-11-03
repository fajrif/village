require 'spec_helper'

describe 'village:articles routes' do
  describe 'default routes' do
    it '/articles to Articles#index' do
      path = village_articles_path
      path.should == '/articles'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'index'
    end

    it '/articles/tags/tag to Articles#index with tag' do
      path = village_articles_path(:tag => 'tag')
      path.should == '/articles/tags/tag'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'index', :tag => 'tag'
    end
    
    it '/articles/2012 to Articles#index with year' do
      path = village_articles_path(:year => '2012')
      path.should == '/articles/2012'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'index', :year => '2012'
    end

    it '/articles/2012/01 to Articles#index with year and month' do
      path = village_articles_path(:year => '2012', :month => '01')
      path.should == '/articles/2012/01'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'index', :year => '2012', :month => '01'
    end

    it '/articles/2012/01/01 to Articles#index with year, month and day' do
      path = village_articles_path(:year => '2012', :month => '01', :day => '01')
      path.should == '/articles/2012/01/01'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'index', :year => '2012', :month => '01', :day => '01'
    end

    it '/articles/2012/01/01/test-article to Articles#show with permalink a format of day' do
      path = village_article_path(:id => '2012/01/01/test-article')
      path.should == '/articles/2012/01/01/test-article'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'show', :id => '2012/01/01/test-article'
    end
  end

  describe 'custom routes' do
    before { Rails.application.routes.clear! }
    after { Rails.application.reload_routes! }

    it '/blog to Articles#index' do
      Rails.application.routes.draw { village :articles, :as => :blog }

      path = village_articles_path
      path.should == '/blog'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'index'
    end
    
    it '/blog/tags/tag to Articles#index' do
      Rails.application.routes.draw { village :articles, :as => :blog }

      path = village_articles_path(:tag => 'tag')
      path.should == '/blog/tags/tag'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'index', :tag => 'tag'
    end

    it '/blog/test-article to Articles#show with a permalink format of slug' do
      Rails.application.routes.draw { village :articles, :as => :blog, :permalink_format => :slug }

      path = village_article_path(:id => 'test-article')
      path.should == '/blog/test-article'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'show', :id => 'test-article'
    end

    it '/blog/2012/test-article to Articles#show with a permalink format of year' do
      Rails.application.routes.draw { village :articles, :as => :blog, :permalink_format => :year }

      path = village_article_path(:id => '2012/test-article')
      path.should == '/blog/2012/test-article'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'show', :id => '2012/test-article'
    end

    it '/blog/2012/01/test-article to Articles#show with permalink a format of month' do
      Rails.application.routes.draw { village :articles, :as => :blog, :permalink_format => :month }

      path = village_article_path(:id => '2012/01/test-article')
      path.should == '/blog/2012/01/test-article'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'show', :id => '2012/01/test-article'
    end

    it '/blog/2012/01/01/test-article to Articles#show with permalink a format of day' do
      Rails.application.routes.draw { village :articles, :as => :blog, :permalink_format => :day }

      path = village_article_path(:id => '2012/01/01/test-article')
      path.should == '/blog/2012/01/01/test-article'
      { :get => path }.should route_to :controller => 'village/articles', :action => 'show', :id => '2012/01/01/test-article'
    end
  end
end
