class BookmarkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.bookmarks
    end
  end

  def create?
    true
  end

  def destroy?
    record.user == user
  end
end
