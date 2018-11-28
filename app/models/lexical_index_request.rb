# frozen_string_literal: true

class LexicalIndexRequest < ActiveRecord::Base
  include AutoReleaseTransaction

  scope :request_of, ->(target) { where target_name: target.name }

  class << self
    def enqueue! target
      transaction do
        request = target.lexical_index_request

        if request
          return false if request.alive?
        else
          request = request_of(target).build
        end

        request.state = :queued
        request.save!
      end
    end

    # This request model may be deleted while executing the job.
    # In that case you will have to rebuild the model.
    def abort! target, error
      transaction do
        request = request_of(target).first_or_initialize
        request.error! error
      end
    end
  end

  def alive?
    state == 'queued' || state == 'runnig'
  end

  def error?
    state == 'error'
  end

  def finished?
    state == 'finished'
  end

  def run!
    transaction do
      self.state = :runnig
      save!
    end
  end

  def finish!
    transaction do
      self.state = :finished
      save!
    end
  end

  def error! err
    transaction do
      self.state = :error
      self.latest_error = err.message
      save!
    end
  end

  def state_icon_for_view
    case state
    when 'queued'
      '<i class="request-state fa fa-pause-circle" aria-hidden="true"></i>'
    when 'runnig'
      '<i class="request-state fa fa-play-circle" aria-hidden="true"></i>'
    when 'finished'
      '<i class="request-state fa fa-check-circle" aria-hidden="true"></i>'
    when 'error'
      '<a href="#request-error-detail" rel="facebox"><i class="request-state request-state--error fa fa-exclamation-circle" aria-hidden="true"></i></a>'
    end
  end
end
