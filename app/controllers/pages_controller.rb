class PagesController < ApplicationController
  layout Village::Config.layout
  
  rescue_from ActionView::MissingTemplate do |exception|
    if exception.message =~ %r{Missing template pages/#{params[:id]}}
      raise ActionController::RoutingError, "No such page: #{params[:id]}"
    else
      raise exception
    end
  end
  
  def show
    render :template => "pages/#{params[:id]}"
  end
end
