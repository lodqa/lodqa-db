# frozen_string_literal: true

class AddEstimatedSecondsToCompleteToLexicalIndexRequest < ActiveRecord::Migration[4.2]
  def change
    add_column :lexical_index_requests, :estimated_seconds_to_complete, :bigint
  end
end
