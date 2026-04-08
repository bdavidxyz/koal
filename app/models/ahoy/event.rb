class Ahoy::Event < ApplicationRecord
  include Lookout::Ahoy::EventMethods
  include Ahoy::QueryMethods

  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true

  serialize :properties, coder: JSON
end
