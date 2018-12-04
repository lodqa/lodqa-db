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

    def resume! target
      transaction do
        request = target.lexical_index_request

        return false unless request&.error?

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

    def abort_zombie_requests!
      transaction do
        where(state: %i[queued running canceling])
          .to_a
          .each { |r| r.error! StandardError.new('This request is a zombie because it was alive at the end of the process. It was forcibly aborted.') }
          .any?
      end
    end
  end

  def alive?
    state == 'queued' || state == 'running'
  end

  def queued?
    state == 'queued'
  end

  def running?
    state == 'running'
  end

  def canceling?
    # Since this method is called from job, we use transactions to release the DB connection immediately.
    transaction do
      state == 'canceling'
    end
  end

  def delete_if_canceling
    transaction do
      delete if reload.canceling?
    rescue ActiveRecord::RecordNotFound
      # The request has already been deleted.
      true
    end
  end

  def error?
    state == 'error'
  end

  def finished?
    state == 'finished'
  end

  def run!
    transaction do
      self.estimated_seconds_to_complete = nil
      self.state = :running
      save!
    end
  end

  def cancel!
    transaction do
      if running?
        self.state = :canceling
        save!
      elsif canceling?
        # do nothing
      else
        delete
      end
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

  def statistics= statistics
    transaction do
      to_complete = statistics.calc_remaining_time[1]
      self.estimated_seconds_to_complete = to_complete
      save!
    end
  end
end
