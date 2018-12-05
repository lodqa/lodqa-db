# frozen_string_literal: true

require 'test_helper'

class ConnectionIndexJobTest < ActiveJob::TestCase
  test 'that job is able to called' do
    ConnectionIndexJob.perform_now targets(:one)
  end
end
