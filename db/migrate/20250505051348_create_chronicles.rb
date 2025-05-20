class CreateChronicles < ActiveRecord::Migration[8.0]
  def change
    create_table :chronicles do |t|
      t.string :slug
      t.string :title
      t.text :kontent

      t.timestamps
    end
  end
end
