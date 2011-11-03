module Village
  class ArticlesController < ApplicationController

    def index
      render :layout => Village::Config.layout
    end

    def show
      resource
      render :layout => Village::Config.layout
    end

  protected

    def resource
      @resource ||= Article.find(params[:id])
    end
    helper_method :resource

    def collection
      @collection ||= Article.where(params.slice(:year, :month, :day, :tag))
      Kaminari.paginate_array(@collection).page(params[:page]).per(Village::Config.page_size)
    end
    helper_method :collection

  end
end
