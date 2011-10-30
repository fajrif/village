class ArticlesController < ApplicationController
  layout Village::Config.layout

  def show
    resource
  end

  def feed
    max_age = 4.hours
    response.headers['Cache-Control'] = 'public, max-age=' + max_age.to_i.to_s
    response.headers['Expires'] = max_age.from_now.httpdate
    response.content_type = 'application/atom+xml'
    fresh_when :last_modified => Article.feed_last_modified
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
