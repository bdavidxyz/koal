class Chronicle < ApplicationRecord
  include SearchableResource

  searchable_attributes :kontent, :chapo, :title
  after_create :generate_decent_slug

  def generate_decent_slug
    self.slug = "chronicle_#{SecureRandom.hex[0...4]}a#{id}" if self.slug.blank?
    self.save
  end
end
