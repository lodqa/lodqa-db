class AddHomeAndPublicityToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :home, :string
    add_column :targets, :publicity, :boolean
  end
end
