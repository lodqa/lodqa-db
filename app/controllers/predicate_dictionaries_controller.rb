# frozen_string_literal: true

class PredicateDictionariesController < ApplicationController
  include TargetNameParams

  def show
    target = Target.find_by! name: target_name
    return head :forbidden unless target.user == current_user

    respond_to do |format|
      format.csv { send_data target.predicate_dictionary.join("\n"), filename: "#{target.name}-predicate-dictionary.csv" }
    end
  end
end
