class CreateChronicles < ActiveRecord::Migration[8.0]
  def change
    create_table :chronicles do |t|
      t.string :slug
      t.string :title
      t.text :chapo
      t.text :kontent
      t.datetime :published_at

      t.timestamps
    end
  end
end
