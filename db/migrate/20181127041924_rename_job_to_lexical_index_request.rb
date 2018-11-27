# frozen_string_literal: true

class RenameJobToLexicalIndexRequest < ActiveRecord::Migration
  def change
    remove_column :jobs, :job_name
    rename_table :jobs, :lexical_index_requests
  end
end
