module Village
  class PagesController < ApplicationController
    rescue_from ActionView::MissingTemplate do |exception|
      if exception.message =~ %r{Missing template "#{params[:id]}"}
        raise ActionController::RoutingError, "No such page: #{params[:id]}"
      else
        raise exception
      end
    end

    def show
      @resource = Page.find(params[:id])
      render :layout => Village::Config.layout
    end
  end
end
