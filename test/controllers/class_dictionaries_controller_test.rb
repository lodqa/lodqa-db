# frozen_string_literal: true

require 'test_helper'

# Since the implementation of InstanceDictionariesController and PredicateDictionariesController is equal to ClassDictionariesController,
# we will substitute this test for their tests.
class ClassDictionariesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    sign_in targets(:one).user
  end

  test 'get the dictionary' do
    response = get :show, target_id: targets(:one).name, format: :csv
    assert_response :success
    assert_equal ['klass', 'http://example.com/klass'], response.body.split("\t")
  end

  test 'can not get the dictionary of targets other than yourself' do
    get :show, target_id: targets(:two).name, format: :csv
    assert_response :forbidden
  end

  test 'can not get the dictionary of targets that do not exist' do
    assert_raises(ActiveRecord::RecordNotFound) { get :show, target_id: 'aaaa', format: :csv }
  end
end
