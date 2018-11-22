require 'test_helper'

class LexicalIndexJobTest < ActiveJob::TestCase
  setup do
    @target = targets :one
    @target.save!
  end

  test 'that job is able to called' do
    LexicalIndexJob.perform_now @target
  end
end
