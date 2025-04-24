module ImmutableSlug
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true, uniqueness: true, if: -> { persisted? }
    after_validation(on: :create) do
      if self.errors.empty? && slug.blank?
        generated_slug_on_creation
      end
    end
    def slug=(new_value)
      super(new_value) unless persisted?
    end
  end
end
