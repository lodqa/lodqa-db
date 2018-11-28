# frozen_string_literal: true

class LexicalIndexRequest < ActiveRecord::Base
  scope :request_of, ->(target) { where target_name: target.name }

  class << self
    def enqueue! target
      request = request_of(target).first_or_initialize
      request.state = :queued
      request.save!
    end

    def abort! target, error
      request = request_of(target).first_or_initialize
      request.error! error
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
    self.state = :runnig
    save!
  end

  def finish!
    self.state = :finished
    save!
  end

  def error! err
    self.state = :error
    self.latest_error = err.message
    save!
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
      '<i class="request-state request-state--error fa fa-exclamation-circle" aria-hidden="true"></i>'
    end
  end
end
