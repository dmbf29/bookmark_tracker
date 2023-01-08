class BookmarksController < ApplicationController
  def index
    @bookmarks = policy_scope(Bookmark)
  end
end
