# frozen_string_literal: true

class CreateKlasses < ActiveRecord::Migration
  def change
    create_table :klasses do |t|
      t.string :target_name, limit: 40, null: false
      t.string :url, limit: 255, null: false
    end
    add_index :klasses, %i[target_name url], unique: true
  end
end
