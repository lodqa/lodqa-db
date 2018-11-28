# frozen_string_literal: true

require 'test_helper'

class ResumeLexicalIndexJobTest < ActiveJob::TestCase
  test 'that job is able to called' do
    ResumeLexicalIndexJob.perform_now targets(:one)
  end
end
