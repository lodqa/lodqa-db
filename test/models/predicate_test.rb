# frozen_string_literal: true

require 'test_helper'

class PredicateTest < ActiveSupport::TestCase
  test 'that class able to insert multi record' do
    Predicate.append 'target_one', [
      'http://exapmle.com',
      'http://exapmle.com/xyz'
    ]
    assert_equal 2, Predicate.where(target_name: 'target_one').count
  end

  test 'that class able to insert multi record without duplication' do
    Predicate.append 'target_one', [
      'http://exapmle.com',
      'http://exapmle.com/xyz',
      'http://exapmle.com/xyz'
    ]
    assert_equal 2, Predicate.where(target_name: 'target_one').count
  end
end
