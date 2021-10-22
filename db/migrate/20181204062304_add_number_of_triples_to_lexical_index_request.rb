# frozen_string_literal: true

class AddNumberOfTriplesToLexicalIndexRequest < ActiveRecord::Migration[4.2]
  def change
    add_column :lexical_index_requests, :number_of_triples, :bigint
  end
end
