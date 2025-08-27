class Blogpost < ApplicationRecord
  include SearchableResource

  searchable_attributes :kontent, :chapo, :title
  after_create :generate_decent_slug

  has_many :blogtag_blogposts
  has_many :blogtags, through: :blogtag_blogposts

  validates :title, presence: true

  def generate_decent_slug
    self.slug = "blogpost_#{SecureRandom.hex[0...4]}a#{id}" if self.slug.blank?
    self.save
  end
end
