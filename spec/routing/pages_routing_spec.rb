require 'spec_helper'

describe 'village:pages routes' do
  context "using default configuration" do

    it "should generate normal resource route with :id" do
      village_page_path(:id => "one").should == "/pages/one"
    end

    it "should generate normal resource route with string" do
      village_page_path("one").should == "/pages/one"
    end

    it "should generate nested route with string" do
      village_page_path("one/two").should == "/pages/one/two"
    end

    it "should recognize nested route" do
      assert_recognizes({ :controller => "village/pages", :action => "show", :id => "one/two" }, "/pages/one/two")
    end

    it "should recognize normal route" do
      assert_recognizes({ :controller => "village/pages", :action => "show", :id => "one" }, "/pages/one")
    end

    it "should recognize normal route with dots" do
      assert_recognizes({ :controller => "village/pages", :action => "show", :id => "one.two.three" }, "/pages/one.two.three")
    end
  end

  context "custom route" do
    before(:all) do
      Rails.application.routes.draw { village :pages, :as => :content }
    end

    it "should generate normal resource route with path" do
      village_page_path(:id => "one").should == "/content/one"
    end

    it "should generate normal resource route with string" do
      village_page_path("one").should == "/content/one"
    end

    it "should generate nested route with string" do
      village_page_path("one/two").should == "/content/one/two"
    end

    it "should recognize nested route" do
      assert_recognizes({:controller => "village/pages", :action => "show", :id => "one/two"}, "/content/one/two")
    end

    it "should recognize normal route" do
      assert_recognizes({:controller => "village/pages", :action => "show", :id => "one"}, "/content/one")
    end

    it "should recognize normal route with dots" do
      assert_recognizes({:controller => "village/pages", :action => "show", :id => "one.two.three"}, "/content/one.two.three")
    end
  end

end
