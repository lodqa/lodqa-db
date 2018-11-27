# frozen_string_literal: true

require 'test_helper'
require 'rr'

class LexicalIndexRequestsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include RR::DSL

  setup do
    @one = targets(:one)
    @one.save!
    sign_in @one.user

    @two = targets(:two)
    @two.save!
  end

  sub_test_case 'create a request' do
    test 'create a request of my target' do
      stub(LexicalIndexJob).perform_later
      post :create, target_id: @one.name
      assert_response :redirect
    end

    test 'can not create requests of targets other than yourself' do
      post :create, target_id: @two.name
      assert_response :forbidden
    end

    test 'can not create requests for targets that do not exist' do
      assert_raises(ActiveRecord::RecordNotFound) { post :create, target_id: 'aaaa' }
    end
  end

  sub_test_case 'delete existing requests' do
    setup do
      request = LexicalIndexRequest.request_of(@one).build
      request.run!

      @one_second = targets(:one_second)
      @one_second.save!
    end

    test 'delete an existing request' do
      post :destroy, target_id: @one.name
      assert_response :redirect
    end

    test 'can not delete a request of targets other than yourself' do
      post :destroy, target_id: @two.name
      assert_response :forbidden
    end

    test 'can not delete not existing request' do
      post :destroy, target_id: @one_second.name
      assert_response :not_found
    end
  end
end
