# frozen_string_literal: true

class ClassDictionariesController < ApplicationController
  include TargetNameParams

  def show
    target = Target.find_by! name: target_name
    return head :forbidden unless target.user == current_user

    respond_to do |format|
      format.csv { send_data target.class_dictionary.join("\n"), filename: "#{target.name}-class-dictionary.csv" }
    end
  end
end
