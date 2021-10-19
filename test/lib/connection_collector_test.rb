# frozen_string_literal: true

require 'test_helper'

class ConnectionCollectorTest < ActiveSupport::TestCase
  setup do
    @endpoint = Collector::Endpoint.new 'http://ep.lodqa.org/qald-biomed/query', nil
  end

  test 'that it be able to count of connections' do
    skip 'The endpoint is unable.'
    count = Collector::ConnectionCollector.count @endpoint
    assert count.is_a? Integer
  end

  test 'that it be able to get all connection' do
    skip 'The endpoint is unable.'
    Collector::ConnectionCollector.get @endpoint do |connections|
      assert connections.count.positive?
      assert connections.first.is_a?(Array)
      assert connections.first[0].is_a?(String)
      assert connections.first[0].is_a?(String)
    end
  end
end
