# frozen_string_literal: true

require 'test_helper'
require 'rr'

class LexicalIndexRequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include RR::DSL

  setup do
    @one = targets(:one)
    @two = targets(:two)
  end

  sub_test_case 'not logged in' do
    test 'A user who is not logged in is requested to log in1' do
      post target_lexical_index_request_url(@one), params: {}
      assert_response :redirect
    end

    test 'Users who are not logged in can not resume' do
      put target_lexical_index_request_url(@one), params: {}
      assert_response :forbidden
    end

    test 'Users who are not logged in can not delete' do
      delete target_lexical_index_request_url(@one), params: {}
      assert_response :forbidden
    end
  end

  sub_test_case 'logged in' do
    setup do
      sign_in @one.user
    end

    sub_test_case 'create a request' do
      test 'create a request of my target' do
        stub(LexicalIndexJob).perform_later
        post target_lexical_index_request_url(@one), params: {}
        assert_response :redirect
      end

      test 'can not create requests of targets other than yourself' do
        post target_lexical_index_request_url(@two), params: {}
        assert_response :forbidden
      end

      test 'can not create requests for targets that do not exist' do
        assert_raises(ActiveRecord::RecordNotFound) { post '/targets/aaaa/connection_index_request', params: {} }
      end
    end

    sub_test_case 'resume a request' do
      setup do
        request = LexicalIndexRequest.request_of(@one).build
        request.error! StandardError.new('')
      end

      test 'resume a request of my target' do
        stub(ResumeLexicalIndexJob).perform_later
        patch target_lexical_index_request_url(@one), params: {}
        assert_response :redirect
      end

      test 'can not resume requests of targets other than yourself' do
        post target_lexical_index_request_url(@two), params: {}
        assert_response :forbidden
      end

      test 'can not resume requests for targets that do not exist' do
        assert_raises(ActiveRecord::RecordNotFound) { post '/targets/aaaa/connection_index_request', params: {} }
      end
    end

    sub_test_case 'delete existing requests' do
      setup do
        request = LexicalIndexRequest.request_of(@one).build
        request.state = :queued
        request.run!
      end

      test 'delete an existing request' do
        delete target_lexical_index_request_url(@one), params: {}
        assert_response :redirect
      end

      test 'can not delete a request of targets other than yourself' do
        delete target_lexical_index_request_url(@two), params: {}
        assert_response :forbidden
      end

      test 'can not delete not existing request' do
        delete target_lexical_index_request_url(targets(:one_second)), params: {}
        assert_response :not_found
      end
    end
  end
end
