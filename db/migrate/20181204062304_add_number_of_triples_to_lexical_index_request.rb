# frozen_string_literal: true

class AddNumberOfTriplesToLexicalIndexRequest < ActiveRecord::Migration
  def change
    add_column :lexical_index_requests, :number_of_triples, :bigint
  end
end
