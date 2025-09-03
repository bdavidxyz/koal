# frozen_string_literal: true

class CreateRabarberRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :rabarber_roles do |t|
      t.string :name, null: false
      t.belongs_to :context, polymorphic: true, index: true
      t.timestamps
    end

    add_index :rabarber_roles, [ :name, :context_type, :context_id ], unique: true

    create_table :rabarber_roles_roleables, id: false do |t|
      t.belongs_to :role, null: false, index: true, foreign_key: { to_table: :rabarber_roles }
      t.belongs_to :roleable, null: false, index: true, foreign_key: { to_table: :users }
    end

    add_index :rabarber_roles_roleables, [ :role_id, :roleable_id ], unique: true
  end
end
