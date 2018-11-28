# frozen_string_literal: true

module Canceled
  extend ActiveSupport::Concern

  def canceled? request
    request.delete if request.reload.canceling?
  end
end
