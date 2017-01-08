class AddPredDictionaryUrlToTarget < ActiveRecord::Migration
  def change
    add_column :targets, :pred_dictionary_url, :string
  end
end
