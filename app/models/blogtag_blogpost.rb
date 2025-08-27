class BlogtagBlogpost < ApplicationRecord
  belongs_to :blogpost
  belongs_to :blogtag
end
