require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  test 'Class exists' do
    assert_not_nil Connection.new
  end

  test 'that it able to insert multi record' do
    Connection.append 'target_one', [
      ['http://exapmle.com/subject1', 'http://exapmle.com/object1'],
      ['http://exapmle.com/subject2', 'http://exapmle.com/object2']
    ]
    assert_equal 2, Connection.where(target_name: 'target_one').count
  end

  test 'that it able to insert multi record without duplication' do
    Connection.append 'target_one', [
      ['http://exapmle.com/subject1', 'http://exapmle.com/object1'],
      ['http://exapmle.com/subject2', 'http://exapmle.com/object2'],
      ['http://exapmle.com/subject2', 'http://exapmle.com/object2']
    ]
    assert_equal 2, Connection.where(target_name: 'target_one').count
  end
end
