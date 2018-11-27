# frozen_string_literal: true

class PredicateDictionariesController < ApplicationController
  def show
    target = Target.find_by!(name: target_id)
    return head :forbidden unless target.user == current_user

    respond_to do |format|
      format.csv { send_data target.predicate_dictionary.join("\n"), filename: "#{target.name}-predicate-dictionary.csv" }
    end
  end

  private

  def target_id
    params.require(:target_id)
  end
end
