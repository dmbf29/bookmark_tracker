class Bookmark < ApplicationRecord
  belongs_to :user
  has_many :bookmark_tags, dependent: :destroy
  has_many :tags, through: :bookmark_tags
  validate :name_or_url
  accepts_nested_attributes_for :bookmark_tags, allow_destroy: true

  private

  def name_or_url
    return unless name.blank? && url.blank?

    errors.add(:base, 'A name and/or URL is required.')
  end
end
