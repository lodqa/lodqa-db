class Target < ActiveRecord::Base
  include FriendlyId
  friendly_id :name

  attr_accessible :description, :user, :dictionary_url, :pred_dictionary_url, :endpoint_url, :graph_uri, :home, :ignore_predicates, :max_hop, :name, :parser_url, :publicity, :sample_queries, :sortal_predicates
  belongs_to :user
  serialize :ignore_predicates, Array
  serialize :sortal_predicates, Array
  serialize :sample_queries, Array

  validates :name, :presence => true
  validates :user, :presence => true
  validates :endpoint_url, :presence => true
  validates :dictionary_url, :presence => true
  validates_uniqueness_of :name

  def editable?(current_user)
    if current_user.present?
      self.user == current_user
    else
      false
    end
  end
end
