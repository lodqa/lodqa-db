require 'test_helper'

class KlassCollectorTest < ActiveSupport::TestCase
  test 'that it be able to count of classes' do
    count = Collector::KlassCollector.count 'http://ep.lodqa.org/qald-biomed/query'
    assert count.is_a? Integer
  end

  test 'that it counts class as zero with impossible sortal_predicates' do
    count = Collector::KlassCollector.count 'http://ep.lodqa.org/qald-biomed/query',
                                            sortal_predicates: ['http://example.com']
    assert_equal 0, count
  end

  test 'that it be able to get all class' do
    Collector::KlassCollector.get 'http://ep.lodqa.org/qald-biomed/query' do |klasses|
      assert klasses.count > 0
      assert klasses.first.is_a?(String)
    end
  end

  test 'that it get no class with a too big initial_offset' do
    Collector::KlassCollector.get 'http://ep.lodqa.org/qald-biomed/query',
                                  initial_offset: 100 do |klasses|
      assert_equal 0, klasses.count
    end
  end

  test 'that it be able to get all class with a small offset_size' do
    Collector::KlassCollector.get 'http://ep.lodqa.org/qald-biomed/query',
                                  offset_size: 5 do |klasses|
      assert klasses.count > 0
    end
  end

  test 'that it get no class with impossible sortal_predicates' do
    Collector::KlassCollector.get 'http://ep.lodqa.org/qald-biomed/query',
                                  sortal_predicates: ['http://example.com'] do |klasses|
      assert_equal 0, klasses.count
    end
  end
end
