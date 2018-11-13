class Target < ActiveRecord::Base
  include FriendlyId
  friendly_id :name

  belongs_to :user
  serialize :ignore_predicates, Array
  serialize :sortal_predicates, Array
  serialize :sample_queries, Array

  validates :name, :presence => true
  validates_format_of :name, :with => /\A[a-zA-Z0-9][a-zA-Z0-9 _-]+\z/i
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
