class CreateBlogtagBlogposts < ActiveRecord::Migration[8.0]
  def change
    create_table :blogtag_blogposts do |t|
      t.belongs_to :blogtag
      t.belongs_to :blogpost

      t.timestamps
    end
  end
end
