require 'test_helper'

class LabelCollectorTest < ActiveSupport::TestCase
  test 'that it be able to count of labels' do
    count = Collector::LabelCollector.count 'http://ep.lodqa.org/qald-biomed/query'
    assert count.is_a? Integer
  end

  test 'that it be able to get all label' do
    Collector::LabelCollector.get 'http://ep.lodqa.org/qald-biomed/query' do |labels|
      assert labels.count > 0
      assert labels.first.is_a?(Array)
      assert labels.first[0].is_a?(String)
      assert labels.first[0].is_a?(String)
    end
  end

  test 'that it get no label with a too big initial_offset' do
    Collector::LabelCollector.get 'http://ep.lodqa.org/qald-biomed/query',
                                  initial_offset: 100_000 do |labels|
      assert_equal 0, labels.count
    end
  end

  test 'that it be able to get all label with a large offset_size' do
    Collector::LabelCollector.get 'http://ep.lodqa.org/qald-biomed/query',
                                  offset_size: 50_000 do |labels|
      assert labels.count > 0
    end
  end
end
