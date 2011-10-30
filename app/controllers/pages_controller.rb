class PagesController < ApplicationController
  
  def show
    render :template => "pages/#{params[:path]}", :layout => Village::Config.layout
  end
end
