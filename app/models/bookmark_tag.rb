class BookmarkTag < ApplicationRecord
  belongs_to :bookmark
  belongs_to :tag
  accepts_nested_attributes_for :tag
end
