class Target < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :user, :dictionary_url, :endpoint_url, :graph_uri, :ignore_predicates, :max_hop, :name, :parser_url, :sample_queries, :sortal_predicates

  def editable?(current_user)
    if current_user.present?
      self.user == current_user
    else
      false
    end
  end

end
