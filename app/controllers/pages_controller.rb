class PagesController < ApplicationController
  rescue_from ActionView::MissingTemplate do |exception|
    if exception.message =~ %r{Missing template pages/#{params[:path]}}
      raise ActionController::RoutingError, "No such page: #{params[:path]}"
    else
      raise exception
    end
  end
  
  def show
    render :template => "pages/#{params[:path]}", :layout => Village::Config.layout
  end
end
