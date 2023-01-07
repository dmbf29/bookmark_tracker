class BookmarkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      current_user.bookmarks
    end
  end

  def create?
    true
  end
end
