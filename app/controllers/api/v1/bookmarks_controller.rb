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
      head :created
    else
      render_error
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:url, :name, :video, bookmark_tags_attributes: [tag_attributes: [:name]])
  end
end


# params[:bookmark][:tags].each do |tag|
#   tag = Tag.where(name: tag.downcase).first_or_create
#   BookmarkTag.create(bookmark: @bookmark, tag: tag)
# end
