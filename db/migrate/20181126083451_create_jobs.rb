# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :target_name, limit: 40, null: false
      t.string :job_name, limit: 30, null: false
      t.string :state, limit: 8, null: false
      t.string :latest_error, limit: 255, null: false, default: ''

      t.timestamps
    end
    add_index :jobs, %i[target_name job_name], unique: true
  end
end
