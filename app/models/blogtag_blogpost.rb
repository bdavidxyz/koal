class BlogtagBlogpost < ApplicationRecord
  self.table_name = 'blogtagblogposts'
  belongs_to :blogpost
  belongs_to :blogtag
end
