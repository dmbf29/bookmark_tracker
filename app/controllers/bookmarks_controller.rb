class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    if params[:token].present?
      @bookmarks = policy_scope(Bookmark)
    else
      user_not_authorized
    end
  end
end
