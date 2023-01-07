class BookmarkTag < ApplicationRecord
  belongs_to :bookmark
  belongs_to :tag
  validates :tag, uniqueness: { scope: :bookmark }
  accepts_nested_attributes_for :tag
end
