class Api::V1::BookmarksController < Api::V1::BaseController

  def index
    @bookmarks = policy_scope(Bookmark)
    render json: @bookmarks
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.user = current_user
    authorize @bookmark
    if @bookmark.save
      render :show, status: :created
    else
      render_error
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:url, :name, bookmark_tags_attributes: [:tag_attributes => [:name]])
  end
end
