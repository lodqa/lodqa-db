class AddPredDictionaryUrlToTarget < ActiveRecord::Migration[4.2]
  def change
    add_column :targets, :pred_dictionary_url, :string
  end
end
