# frozen_string_literal: true

require 'test_helper'
require 'rr'

class LexicalIndexJobControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include RR::DSL

  setup do
    target = targets(:one)
    target.save!
    sign_in target.user

    targets(:two).save!
  end

  test 'should return 204' do
    stub(LexicalIndexJob).perform_later
    post :create, target_id: :one
    assert_response :success
  end

  test 'should not create jobs for targets other than yourself' do
    post :create, target_id: :two
    assert_response :forbidden
  end

  test 'should not create jobs for targets that do not exist' do
    assert_raises(ActiveRecord::RecordNotFound) { post :create, target_id: 'aaaa' }
  end
end
