class BookmarksController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index, :destroy]

  def index
    @bookmarks = policy_scope(Bookmark).order(:name)
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    authorize @bookmark
    @bookmark.destroy
    redirect_to bookmarks_path(token: params[:token]), status: :see_other
  end
end
