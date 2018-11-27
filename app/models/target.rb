# frozen_string_literal: true

class Target < ActiveRecord::Base
  include FriendlyId
  friendly_id :name

  belongs_to :user
  has_one :lexical_index_request, primary_key: :name, foreign_key: :target_name
  serialize :ignore_predicates, Array
  serialize :sortal_predicates, Array
  serialize :sample_queries, Array

  validates :name, presence: true
  validates_format_of :name, with: /\A[a-zA-Z0-9][a-zA-Z0-9 _-]+\z/i
  validates :user, presence: true
  validates :endpoint_url, presence: true
  validates :dictionary_url, presence: true
  validates_uniqueness_of :name

  def editable? current_user
    if current_user.present?
      user == current_user
    else
      false
    end
  end

  def ignore_predicates_for_view
    ignore_predicates.join("\n")
  end

  def ignore_predicates_for_view= str
    self.ignore_predicates = str.split(/[\n\r\t]+/)
  end

  def sortal_predicates_for_view
    sortal_predicates.join("\n")
  end

  def sortal_predicates_for_view= str
    self.sortal_predicates = str.split(/[\n\r\t]+/)
  end

  def sample_queries_for_view
    sample_queries.join("\n")
  end

  def sample_queries_for_view= str
    self.sample_queries = str.split(/[\n\r\t]+/)
  end
end
