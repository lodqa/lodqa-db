# frozen_string_literal: true

require 'test_helper'

class ConnectionIndexRequestTest < ActiveSupport::TestCase
  test 'Class exists' do
    assert_not_nil ConnectionIndexRequest.new
  end

  sub_test_case 'satetes' do
    test 'a queued request is alive' do
      assert connection_index_requests(:queued).alive?
    end

    test 'a running request is alive' do
      assert connection_index_requests(:running).alive?
    end

    test 'a queued request is queued' do
      assert connection_index_requests(:queued).queued?
    end

    test 'a running request is running' do
      assert connection_index_requests(:running).running?
    end

    test 'a canceling request is canceling' do
      assert connection_index_requests(:canceling).canceling?
    end

    test 'an error request is error' do
      assert connection_index_requests(:error).error?
    end

    test 'a finished request is finished' do
      assert connection_index_requests(:finished).finished?
    end
  end

  sub_test_case 'satete operations' do
    sub_test_case 'run!' do
      test 'a ruquest is running after run' do
        request = connection_index_requests :queued
        request.run!
        assert request.running?
      end

      test 'the estimated_seconds_to_complete is nil after run' do
        request = connection_index_requests :queued
        request.run!
        assert_nil request.estimated_seconds_to_complete
      end

      test 'raise RequestInvalidStateError if a request with other than queued state runs' do
        assert_raise(RequestInvalidStateError) { connection_index_requests(:running).run! }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:canceling).run! }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:error).run! }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:finished).run! }
      end
    end

    sub_test_case 'cancel!' do
      test 'a runnnig ruquest is canceling after cancel' do
        request = connection_index_requests :running
        request.cancel!
        assert request.canceling?
      end

      test 'a canceling ruquest stays in canceling after cancel' do
        request = connection_index_requests :canceling
        request.cancel!
        assert request.canceling?
      end

      test 'a ruquest with other states is destroyed after cancel' do
        request = connection_index_requests :queued
        request.cancel!
        assert request.destroyed?
      end
    end

    sub_test_case 'delete if canceling!' do
      test 'a canceling request is destroyed after elete if state is canceling' do
        request = connection_index_requests(:canceling)
        assert request.delete_if_canceling!
        assert request.destroyed?
      end

      test 'a request with other states stays same state after elete if state is canceling' do
        request = connection_index_requests(:queued)
        assert_nil request.delete_if_canceling!
        assert request.queued?
      end
    end

    sub_test_case 'finish!' do
      test 'a request is finished after finish' do
        request = connection_index_requests(:running)
        request.finish!
        assert request.finished?
      end

      test 'raise RequestInvalidStateError if a request with other than runnnig state finish' do
        assert_raise(RequestInvalidStateError) { connection_index_requests(:queued).finish! }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:canceling).finish! }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:error).finish! }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:finished).finish! }
      end
    end

    sub_test_case 'error!' do
      setup do
        @request = connection_index_requests(:queued)
        @request.error! StandardError.new 'test message'
      end

      test 'a request is error after error' do
        assert @request.error?
      end

      test 'a request has an error message after error' do
        assert_equal 'test message', @request.latest_error
      end
    end
  end

  sub_test_case 'properties' do
    sub_test_case 'statistics' do
      test 'the estimated_seconds_to_complete is set after the statistics is set' do
        request = connection_index_requests(:running)
        request.statistics = Collector::Statistics.new 'type', { start_at: Time.now }, 100, 10, 10
        assert_not_nil request.estimated_seconds_to_complete
      end

      test 'raise RequestInvalidStateError if a request with other than running state is set statistics' do
        assert_raise(RequestInvalidStateError) { connection_index_requests(:queued).statistics = nil }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:canceling).statistics = nil }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:error).statistics = nil }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:finished).statistics = nil }
      end
    end

    sub_test_case 'number_of_triples' do
      test 'the number_of_triples is set after the number_of_triples is set' do
        request = connection_index_requests(:running)
        request.number_of_triples = 123
        assert_equal 123, request.number_of_triples
      end

      test 'raise RequestInvalidStateError if a request with other than running state is set number_of_triples' do
        assert_raise(RequestInvalidStateError) { connection_index_requests(:queued).number_of_triples = nil }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:canceling).number_of_triples = nil }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:error).number_of_triples = nil }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:finished).number_of_triples = nil }
      end

      test 'raise RequestInvalidStateError if a request with other than running state is get number_of_triples' do
        assert_raise(RequestInvalidStateError) { connection_index_requests(:queued).number_of_triples }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:canceling).number_of_triples }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:error).number_of_triples }
        assert_raise(RequestInvalidStateError) { connection_index_requests(:finished).number_of_triples }
      end
    end
  end

  sub_test_case 'class methods' do
    test 'abort living requests' do
      ConnectionIndexRequest.abort_zombie_requests!
      assert connection_index_requests(:queued).error?
      assert connection_index_requests(:running).error?
      assert connection_index_requests(:canceling).error?
      assert connection_index_requests(:error).error?
      assert connection_index_requests(:finished).finished?
    end
  end
end
