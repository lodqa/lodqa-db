# frozen_string_literal: true

class LexicalIndexRequestsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

  def create
    target = Target.find_by!(name: target_id)
    return head :forbidden unless target.user == current_user

    request = target.lexical_index_request
    return head :conflict if request&.alive?

    LexicalIndexRequest.queue_lexical_index_request! target
    LexicalIndexJob.perform_later target

    head :no_content
  end

  def destroy
    target = Target.find_by!(name: target_id)
    return head :forbidden unless target.user == current_user

    request = target.lexical_index_request
    return head :not_found unless request

    request.delete

    redirect_to target
  end

  private

  def target_id
    params.require(:target_id)
  end
end