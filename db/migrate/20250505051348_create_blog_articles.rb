class CreateBlogArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_articles do |t|
      t.string :slug
      t.string :title
      t.text :kontent

      t.timestamps
    end
  end
end
