class BookmarkTag < ApplicationRecord
  belongs_to :bookmark
  belongs_to :tag
  validates :tag, uniqueness: { scope: :bookmark }
end
