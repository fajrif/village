require 'spec_helper'

describe Village::Article do
  def test_article(file_name)
    Article.new(File.dirname(__FILE__) + "/../support/data/articles/#{file_name}")
  end

  it 'should not initialise with bad filename' do
    lambda { test_article 'missing-date-from-filename.markdown' }.should raise_error
  end

  context 'with missing file' do
    subject { test_article '2000-01-01-no-such-file.markdown' }
    it 'should error when trying to read content' do
      lambda { subject.content }.should raise_error
    end
  end

  context 'with first article' do
    subject { test_article '2011-04-01-first-article.markdown' }
    its(:slug) { should == 'first-article' }
    its(:date) { should == Date.parse('2011-04-01') }
    its(:title) { should == 'Test Village' }
    its(:content) { should =~ /\ALorem ipsum/ }
    its(:content_html) { should =~ /^<p>Lorem ipsum/ }
    its(:content_html) { should =~ /^<p>Duis aute irure dolor/ }
    its(:content_html) { should be_html_safe }
    its(:summary_html) { should =~ /^<p>Lorem ipsum/ }
    its(:summary_html) { should_not =~ /^<p>Duis aute irure dolor/ }
    its(:summary_html) { should be_html_safe }
  end

  context 'with custom title article' do
    subject { test_article '2015-02-13-custom-title.markdown' }
    its(:slug) { should == 'custom-title' }
    its(:date) { should == Date.parse('2015-02-13') }
    its(:title) { should == 'This is a custom title' }
    its(:content) { should == "Content goes here.\n" }
  end
  
  context 'with RDoc templating engine' do
    subject { test_article '2011-04-01-first-article.rdoc' }
    its(:slug) { should == 'first-article' }
    its(:date) { should == Date.parse('2011-04-01') }
    its(:title) { should == 'Article with RDoc template' }
    its(:content_html) { should =~ /^<h2 id="label-Header">Header<\/h2>/ }
  end

  context 'with author' do
    subject { 
      test_article '2011-05-01-full-metadata.markdown' 
      author[:name].should eql('John Smith')
      author[:email].should eql('john.smith@example.com')
    }
  end
  
  context 'with tags' do
    subject { test_article '2011-05-01-full-metadata.markdown' }
    its(:tags) { should == ["Village", "Markdown"] }
  end

  context 'with image article' do
    subject { test_article '2011-04-28-image.markdown' }
    its(:summary_html) { should =~ /^<p>Image description/ }
    its(:summary_html) { should be_html_safe }
  end

  context 'with custom summary article' do
    subject { test_article '2011-04-28-summary.markdown' }
    its(:summary_html) { should == '<p>This is a custom &amp; test summary.</p>' }
    its(:summary_html) { should be_html_safe }
  end

  context 'with alternate markdown file extension' do
    it 'should accept *.md files' do
      lambda { test_article('2011-05-02-md-file-extension.md').content }.should_not raise_error
    end

    it 'should accept *.mkd files' do
      lambda { test_article('2011-05-02-mkd-file-extension.mkd').content }.should_not raise_error
    end

    it 'should accept *.mdown files' do
      lambda { test_article('2011-05-02-mdown-file-extension.mdown').content }.should_not raise_error
    end
  end
end
