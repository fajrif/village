class PagesController < ApplicationController
  layout Village::Config.layout
  
  rescue_from ActionView::MissingTemplate do |exception|
    if exception.message =~ %r{Missing template pages/#{params[:path]}}
      raise ActionController::RoutingError, "No such page: #{params[:path]}"
    else
      raise exception
    end
  end
  
  def show
    render :template => "pages/#{params[:path]}"
  end
end
