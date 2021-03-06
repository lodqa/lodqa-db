# frozen_string_literal: true

module IndexRequest
  extend ActiveSupport::Concern
  include AutoReleaseTransaction

  included do
    scope :request_of, ->(target) { where target_name: target.name }
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

  def error?
    state == 'error'
  end

  def finished?
    state == 'finished'
  end

  def run!
    transaction do
      raise RequestInvalidStateError unless queued?

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

  def delete_if_canceling!
    transaction do
      delete if reload.canceling?
    rescue ActiveRecord::RecordNotFound
      # The request has already been deleted.
      true
    end
  end

  def finish!
    transaction do
      raise RequestInvalidStateError unless running?

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
      raise RequestInvalidStateError unless running?

      to_complete = statistics.calc_remaining_time[1]
      self.estimated_seconds_to_complete = to_complete
      save!
    end
  end

  def number_of_triples= count
    transaction do
      raise RequestInvalidStateError unless running?

      write_attribute :number_of_triples, count
      save!
    end
  end

  def number_of_triples
    transaction do
      raise RequestInvalidStateError unless running?

      read_attribute :number_of_triples
    end
  end

  class_methods do
    def abort_zombie_requests!
      transaction do
        where(state: %i[queued running canceling])
          .to_a
          .each { |r| r.error! StandardError.new('This request is a zombie because it was alive at the end of the process. It was forcibly aborted.') }
          .any?
      end
    end
  end
end
