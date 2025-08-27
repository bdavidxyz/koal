class Blogtag < ApplicationRecord
  include ImmutableSlug
  include SearchableResource

  searchable_attributes :slug, :name

  has_many :blogtagblogposts
  has_many :blogposts, through: :blogtagblogposts

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }

  def generated_slug_on_creation
    self.slug = "#{name.parameterize}"
  end
end
