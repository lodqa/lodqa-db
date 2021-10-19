# frozen_string_literal: true

require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  test 'Class exists' do
    assert_not_nil Connection.new
  end

  sub_test_case 'Breadth-First Traversal' do
    test '1-2, 2-2 is get from 1-2 connection' do
      result = Connection.breadth_first_traversal 'conncetion_set_one'
      assert_equal 2, result.length
      assert result.include?('subject' => '1', 'object' => '1')
      assert result.include?('subject' => '2', 'object' => '2')
    end

    test '1-1, 2-2, 3-3, 1-3 and 3-1 are get from 1-2 2-3 connection' do
      result = Connection.breadth_first_traversal 'conncetion_set_two'
      assert_equal 5, result.length
      assert result.include?('subject' => '1', 'object' => '1')
      assert result.include?('subject' => '2', 'object' => '2')
      assert result.include?('subject' => '3', 'object' => '3')
      assert result.include?('subject' => '1', 'object' => '3')
      assert result.include?('subject' => '3', 'object' => '1')
    end

    test '1-1 is get from 1-2 2-2 connection' do
      result = Connection.breadth_first_traversal 'conncetion_set_three'
      assert_equal 1, result.length
      assert result.include?('subject' => '1', 'object' => '1')
    end

    test '1-1, 2-2 ,3-3, 2-3 and 3-2 are get from 1-2 1-3 connection' do
      result = Connection.breadth_first_traversal 'conncetion_set_four'
      assert_equal 5, result.length
      assert result.include?('subject' => '1', 'object' => '1')
      assert result.include?('subject' => '2', 'object' => '2')
      assert result.include?('subject' => '3', 'object' => '3')
      assert result.include?('subject' => '2', 'object' => '3')
      assert result.include?('subject' => '3', 'object' => '2')
    end
  end

  sub_test_case 'append' do
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
end
