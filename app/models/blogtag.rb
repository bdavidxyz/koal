class Blogtag < ApplicationRecord
  include ImmutableSlug
  include SearchableResource

  searchable_attributes :slug, :name

  has_many :blogtag_blogposts
  has_many :blogposts, through: :blogtag_blogposts

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }

  def generated_slug_on_creation
    self.slug = "#{name.parameterize}"
  end
end
