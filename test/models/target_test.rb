# frozen_string_literal: true

require 'test_helper'

class TargetTest < ActiveSupport::TestCase
  test 'get the insnace dictionary' do
    dic = targets(:one).instance_dictionary

    assert_equal 1, dic.count
    assert_equal labels(:insnace), dic.first
  end
end
