# frozen_string_literal: true

require 'test_helper'

class ResumeConnectionIndexJobTest < ActiveJob::TestCase
  test 'that job is able to called' do
    ResumeConnectionIndexJob.perform_now targets(:one)
  end
end
