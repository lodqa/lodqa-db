# frozen_string_literal: true

class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :target_name, limit: 40, null: false
      t.string :url, limit: 255, null: false
      t.string :label, limit: 255, null: false
    end
    add_index :labels, %i[target_name url label], unique: true
  end
end
