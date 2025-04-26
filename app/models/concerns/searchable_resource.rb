module SearchableResource
  extend ActiveSupport::Concern

  class_methods do
    def searchable_attributes(*attributes)
      @searchable_attributes = attributes if attributes.any?
      @searchable_attributes || []
    end
  end
end
