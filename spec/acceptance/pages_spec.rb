require 'spec_helper'

describe 'Page views', :type => :request do

  context 'Pages#show' do
    after(:each) do
      page.should have_content('Header')
      page.should have_content('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.')
    end
    
    it 'should render valid ERB page' do
      visit page_path("erb/test-page")
    end
    
    it 'should render valid HAML page' do
      visit page_path("haml/test-page")
    end
  end

  context 'Pages#show with invalid path' do
    it 'should raise an not found exception' do
      lambda do
        visit page_path('help/to/do/this')
      end.should raise_error(ActionView::MissingTemplate)
    end
  end

end
