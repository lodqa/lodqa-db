# frozen_string_literal: true

class AddHomeAndPublicityToTargets < ActiveRecord::Migration[4.2]
  def change
    add_column :targets, :home, :string
    add_column :targets, :publicity, :boolean
  end
end
