# frozen_string_literal: true

require 'test_helper'

class LabelCollectorTest < ActiveSupport::TestCase
  setup do
    @endpoint = Collector::Endpoint.new 'http://ep.lodqa.org/qald-biomed/query', nil
  end

  test 'that it be able to count of labels' do
    skip 'The endpoint is unable.'
    count = Collector::LabelCollector.count @endpoint
    assert count.is_a? Integer
  end

  test 'that it be able to get all label' do
    skip 'The endpoint is unable.'
    Collector::LabelCollector.get @endpoint do |labels|
      assert labels.count.positive?
      assert labels.first.is_a?(Array)
      assert labels.first[0].is_a?(String)
      assert labels.first[0].is_a?(String)
    end
  end

  test 'that it get no label with a too big initial_offset' do
    skip 'The endpoint is unable.'
    Collector::LabelCollector.get @endpoint,
                                  initial_offset: 100_000 do |labels|
      assert_equal 0, labels.count
    end
  end

  test 'that it be able to get all label with a large offset_size' do
    skip 'The endpoint is unable.'
    Collector::LabelCollector.get @endpoint,
                                  offset_size: 50_000 do |labels|
      assert labels.count.positive?
    end
  end
end
