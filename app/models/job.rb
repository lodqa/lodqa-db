# frozen_string_literal: true

class Job < ActiveRecord::Base
  scope :for_job, ->(target_name, job_name) {
    where target_name: target_name, job_name: job_name
  }
  scope :for_lexical_index_job, ->(target_name) { for_job target_name, :lexical_index }

  class << self
    def queue_lexical_index_job! target_name
      job = for_lexical_index_job(target_name)
            .first_or_initialize

      job.state = :queued
      job.save!
    end

    def abort_lexical_index_job! target_name, error
      job = for_lexical_index_job(target_name)
            .first_or_initialize
      job.error! error
    end
  end

  def alive?
    state == 'queued' || state == 'runnig'
  end

  def error?
    state == 'error'
  end

  def run!
    self.state = :runnig
    save!
  end

  def finish!
    self.state = :finish
    save!
  end

  def error! e
    self.state = :error
    self.latest_error = e.message
    save!
  end

  def state_icon_for_view
    case state
    when 'queued'
      '<i class="job-state fa fa-pase-circle" aria-hidden="true"></i>'
    when 'runnig'
      '<i class="job-state fa fa-play-circle" aria-hidden="true"></i>'
    when 'finished'
      '<i class="job-state fa fa-check-circle" aria-hidden="true"></i>'
    when 'error'
      '<i class="job-state job-state--error fa fa-exclamation-circle" aria-hidden="true"></i>'
    end
  end
end
