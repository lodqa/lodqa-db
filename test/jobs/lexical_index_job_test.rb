# frozen_string_literal: true

require 'test_helper'

class LexicalIndexJobTest < ActiveJob::TestCase
  test 'that job is able to called' do
    LexicalIndexJob.perform_now targets(:one)
  end
end
