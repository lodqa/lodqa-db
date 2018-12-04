# frozen_string_literal: true

module Collector
  module Collector
    DEFAULT_OFFSET_SIZE = 10_000

    def count endpoint, options = nil
      r = endpoint.get_as_json sparql_to_count(options)
      r[0]&.dig('count', 'value').to_i
    end

    def get endpoint, initial_offset: 0, total_count: nil, **options, &block
      total_count = get_total endpoint, total_count, options
      get_all endpoint, initial_offset, total_count, options, &block
    end

    private

    def get_total endpoint, total_count, options
      total_count ||= count endpoint, options
      Rails.logger.debug "total #{total_count}"

      total_count
    end

    def get_all endpoint, initial_offset, total_count, options
      offset_size = DEFAULT_OFFSET_SIZE
      done_count = initial_offset
      loop do
        start_at = Time.now

        results = get_part endpoint, done_count, offset_size, options

        done_count += results.count

        # Adjust the offset value according to the number of actually taken.
        offset_size = results.count

        yield results, Statistics.new(type, { start_at: start_at, end_at: Time.now }, total_count, done_count, results.count)

        break if done_count >= total_count
      end
    end

    def get_part endpoint, offset, limit, options
      sparql = sparql_to_get offset, limit, options
      r = endpoint.get_as_json sparql
      r.map(&converter)
    end

    def type
      name.split('::').last.sub('Collector', '').downcase.pluralize
    end
  end
end
