# frozen_string_literal: true

class LexicalIndexJobController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

  def create
    target = Target.find_by!(name: target_id)
    return head :forbidden unless target.user == current_user

    job = Job.for_lexical_index_job(target_id).first
    return head :conflict if job&.alive?

    Job.queue_lexical_index_job! target_id
    LexicalIndexJob.perform_later target

    head :no_content
  end

  private

  def target_id
    params.require(:target_id)
  end
end
