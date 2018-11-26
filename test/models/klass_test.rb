# frozen_string_literal: true

require 'test_helper'

class KlassTest < ActiveSupport::TestCase
  test 'that it able to insert multi record' do
    Klass.append 'target_one', [
      'http://exapmle.com',
      'http://exapmle.com/xyz'
    ]
    assert_equal 2, Klass.where(target_name: 'target_one').count
  end

  test 'that it able to insert multi record without duplication' do
    Klass.append 'target_one', [
      'http://exapmle.com',
      'http://exapmle.com/xyz',
      'http://exapmle.com/xyz'
    ]
    assert_equal 2, Klass.where(target_name: 'target_one').count
  end
end
