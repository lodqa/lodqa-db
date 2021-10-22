# frozen_string_literal: true

class CreateConnections < ActiveRecord::Migration[4.2]
  def change
    create_table :connections do |t|
      t.string :target_name, limit: 40, null: false
      t.string :subject, limit: 255, null: false
      t.string :object, limit: 255, null: false

      t.timestamps null: false
    end
    add_index :connections, %i[target_name subject object], unique: true
  end
end
