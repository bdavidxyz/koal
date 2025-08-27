Rabarber::Role.class_eval do
  validates :name, presence: true, uniqueness: true, format: /\A[a-z0-9_]+\z/, length: { minimum: 2 }
end
