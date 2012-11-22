class TagsController < ApplicationController
  def show
    path = params[:path]
    limit = params[:limit].to_i
    limit = 50 if limit <= 0
    if path
      @tag = Tag.find_by_path(path.split("/"))
      @assets = @tag.assets.not_deleted.random(limit)
    else
      @assets = Asset.not_deleted.random(limit)
    end
  end
end