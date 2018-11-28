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

  def queued?
    state == 'queued'
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
end
