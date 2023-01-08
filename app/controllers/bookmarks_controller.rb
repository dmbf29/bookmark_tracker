class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @bookmarks = policy_scope(Bookmark)
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to bookmarks_path(token: params[:token])
  end
end
