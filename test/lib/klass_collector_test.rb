# frozen_string_literal: true

require 'test_helper'

class KlassCollectorTest < ActiveSupport::TestCase
  setup do
    @endpoint = Collector::Endpoint.new 'http://ep.lodqa.org/qald-biomed/query', nil
  end

  test 'that it be able to count of classes' do
    skip 'The endpoint is unable.'
    count = Collector::KlassCollector.count @endpoint
    assert count.is_a? Integer
  end

  test 'that it counts class as zero with impossible sortal_predicates' do
    skip 'The endpoint is unable.'
    count = Collector::KlassCollector.count @endpoint,
                                            sortal_predicates: ['http://example.com']
    assert_equal 0, count
  end

  test 'that it be able to get all class' do
    skip 'The endpoint is unable.'
    Collector::KlassCollector.get @endpoint do |klasses|
      assert klasses.count.positive?
      assert klasses.first.is_a?(String)
    end
  end

  test 'that it get no class with a too big initial_offset' do
    skip 'The endpoint is unable.'
    Collector::KlassCollector.get @endpoint,
                                  initial_offset: 100 do |klasses|
      assert_equal 0, klasses.count
    end
  end

  test 'that it be able to get all class with a small offset_size' do
    skip 'The endpoint is unable.'
    Collector::KlassCollector.get @endpoint,
                                  offset_size: 5 do |klasses|
      assert klasses.count.positive?
    end
  end

  test 'that it get no class with impossible sortal_predicates' do
    skip 'The endpoint is unable.'
    Collector::KlassCollector.get @endpoint,
                                  sortal_predicates: ['http://example.com'] do |klasses|
      assert_equal 0, klasses.count
    end
  end

  test 'that it be able to get all class with empty sortal_predicates' do
    skip 'The endpoint is unable.'
    Collector::KlassCollector.get @endpoint,
                                  sortal_predicates: [] do |klasses|
      assert klasses.count.positive?
    end
  end
end
