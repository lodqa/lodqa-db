# frozen_string_literal: true

class CreateConnectionIndexRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :connection_index_requests do |t|
      t.string :target_name, limit: 40, null: false
      t.string :state, limit: 8, null: false
      t.string :latest_error, limit: 255, default: '', null: false
      t.integer :estimated_seconds_to_complete, limit: 8
      t.integer :number_of_triples, limit: 8

      t.timestamps null: false
    end
  end
end
