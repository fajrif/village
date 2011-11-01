class ArticlesController < ApplicationController
  layout Village::Config.layout

  def show
    resource
  end

protected

  def resource
    @resource ||= Article.find(params[:id])
  end
  helper_method :resource

  def collection
    @collection ||= Article.where(params.slice(:year, :month, :day, :tag))
    Kaminari.paginate_array(@collection).page(params[:page]).per(Article.page_size)
  end
  helper_method :collection

end
