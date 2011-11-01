require 'spec_helper'

describe 'village:pages routes' do
  context "using default configuration" do

    it "should generate normal resource route with :id" do
      page_path(:id => "one").should == "/one"
    end

    it "should generate normal resource route with string" do
      page_path("one").should == "/one"
    end

    it "should generate nested route with string" do
      page_path("one/two").should == "/one/two"
    end

    it "should recognize nested route" do
      assert_recognizes({ :controller => "pages", :action => "show", :id => "one/two" }, "/one/two")
    end

    it "should recognize normal route" do
      assert_recognizes({ :controller => "pages", :action => "show", :id => "one" }, "/one")
    end

    it "should recognize normal route with dots" do
      assert_recognizes({ :controller => "pages", :action => "show", :id => "one.two.three" }, "/one.two.three")
    end
  end

  context "custom route" do
    before(:all) do
      Rails.application.routes.draw { village :pages, :as => :content }
    end

    it "should generate normal resource route with path" do
      page_path(:id => "one").should == "/content/one"
    end

    it "should generate normal resource route with string" do
      page_path("one").should == "/content/one"
    end

    it "should generate nested route with string" do
      page_path("one/two").should == "/content/one/two"
    end

    it "should recognize nested route" do
      assert_recognizes({:controller => "pages", :action => "show", :id => "one/two"}, "/content/one/two")
    end

    it "should recognize normal route" do
      assert_recognizes({:controller => "pages", :action => "show", :id => "one"}, "/content/one")
    end

    it "should recognize normal route with dots" do
      assert_recognizes({:controller => "pages", :action => "show", :id => "one.two.three"}, "/content/one.two.three")
    end
  end

end
