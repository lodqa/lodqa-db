class CreatePredicates < ActiveRecord::Migration
  def change
    create_table :predicates do |t|
      t.string :target_name, limit: 40, null: false
      t.string :url, limit: 255, null: false
    end
    add_index :predicates, %i[target_name url], unique: true
  end
end
