# frozen_string_literal: true

require 'test_helper'

class PredicateCollectorTest < ActiveSupport::TestCase
  IGNORE_PREDICATES = ['http://www.w3.org/2000/01/rdf-schema#seeAlso',
                       'http://www.w3.org/2002/07/owl#sameAs',
                       'http://www.w3.org/2002/07/owl#equivalentProperty',
                       'http://www.w3.org/2002/07/owl#equivalentClass'].freeze

  setup do
    @endpoint = Collector::Endpoint.new 'http://ep.lodqa.org/qald-biomed/query', nil
  end

  test 'that it be able to count of predicates' do
    count = Collector::PredicateCollector.count @endpoint
    assert count.is_a? Integer
  end

  test 'that it counts predicates with optional ignore_predicates' do
    count = Collector::PredicateCollector.count @endpoint
    count_with_ignore_predeciates = Collector::PredicateCollector.count @endpoint,
                                                                        ignore_predicates: IGNORE_PREDICATES
    assert count > count_with_ignore_predeciates
  end

  test 'that it be able to get all predicate' do
    Collector::PredicateCollector.get @endpoint do |predicates|
      assert predicates.count.positive?
      assert predicates.first.is_a?(String)
    end
  end

  test 'that it get no predicate with a too big initial_offset' do
    Collector::PredicateCollector.get @endpoint,
                                      initial_offset: 500 do |predicates|
      assert_equal 0, predicates.count
    end
  end

  test 'that it be able to get all predicate with a small offset_size' do
    Collector::PredicateCollector.get @endpoint,
                                      offset_size: 50 do |predicates|
      assert predicates.count.positive?
    end
  end

  test 'that it get predicates with optional ignore_predicates' do
    Collector::PredicateCollector.get @endpoint,
                                      ignore_predicates: IGNORE_PREDICATES do |predicates|
      assert predicates.count.positive?
      assert predicates.first.is_a?(String)
    end
  end
end
