class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @bookmarks = policy_scope(Bookmark)
  end
end
