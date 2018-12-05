# frozen_string_literal: true

class LexicalIndexRequestsController < ApplicationController
  include TargetNameParams
  before_filter :authenticate_user!, only: [:create]

  def create
    target = Target.find_by! name: target_name
    return head :forbidden unless target.user == current_user
    return head :conflict unless target.enqueue! LexicalIndexRequest

    LexicalIndexJob.perform_later target

    redirect_to target
  end

  def update
    target = Target.find_by! name: target_name
    return head :forbidden unless target.user == current_user
    return head :conflict unless target.resume! LexicalIndexRequest

    ResumeLexicalIndexJob.perform_later target

    redirect_to target
  end

  def destroy
    target = Target.find_by! name: target_name
    return head :forbidden unless target.user == current_user

    request = target.lexical_index_request
    return head :not_found unless request

    request.cancel!

    redirect_to target
  end
end
