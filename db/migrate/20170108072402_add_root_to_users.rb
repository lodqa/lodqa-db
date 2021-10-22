class AddRootToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :root, :boolean, default:false
  end
end
