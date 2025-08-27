
# == Schema Information
#
# Table name: ctags
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Blogtag < ApplicationRecord
  include ImmutableSlug
  include SearchableResource

  searchable_attributes :slug, :name

  has_many :blogtagblogposts
  has_many :blogposts, through: :blogtagblogposts

  validates :name, presence: true, uniqueness: true

  def generated_slug_on_creation
    self.slug = "#{name.parameterize}"
  end
end
