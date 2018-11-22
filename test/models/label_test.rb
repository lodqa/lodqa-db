require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  test 'that it able to insert multi record' do
    Label.append 'target_one', [
      ['abc', 'http://exapmle.com'],
      ['xyz', 'http://exapmle.com/xyz']
    ]
    assert_equal 2, Label.where(target_name: 'target_one').count
  end

  test 'that it able to insert multi record without duplication' do
    Label.append 'target_one', [
      ['abc', 'http://exapmle.com'],
      ['xyz', 'http://exapmle.com/xyz'],
      ['xyz', 'http://exapmle.com/xyz'],
      ['abc', 'http://exapmle.com/xyz']
    ]
    assert_equal 3, Label.where(target_name: 'target_one').count
  end
end
