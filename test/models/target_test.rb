# frozen_string_literal: true

require 'test_helper'

class TargetTest < ActiveSupport::TestCase
  test 'get the insnace dictionary' do
    dic = targets(:one).instance_dictionary

    assert_equal 1, dic.count
    assert_equal labels(:insnace), dic.first
  end

  test 'get the class dictionary' do
    dic = targets(:one).class_dictionary

    assert_equal 1, dic.count
    assert_equal labels(:klass), dic.first
  end

  test 'get the predicate dictionary' do
    dic = targets(:one).predicate_dictionary

    assert_equal 1, dic.count
    assert_equal labels(:predicate), dic.first
  end
end
