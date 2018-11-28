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

    def get_all endpoint, initial_offset, total_count, options, &block
      offset_size = DEFAULT_OFFSET_SIZE
      done_count = initial_offset
      loop do
        start_at = Time.now

        # Adjust the offset value according to the number of actually taken.
        done_count, offset_size = get_a_part endpoint, done_count, offset_size, options, &block

        show_plan_to_complete start_at, total_count, done_count, offset_size

        break if done_count >= total_count
      end
    end

    def get_a_part endpoint, done_count, offset_size, options
      labels = get_part endpoint, done_count, offset_size, options
      yield labels

      [done_count + labels.count, labels.count]
    end

    def get_part endpoint, offset, limit, options
      sparql = sparql_to_get offset, limit, options
      r = endpoint.get_as_json sparql
      r.map(&converter)
    end

    def show_plan_to_complete start_at, total_count, done_count, acquired_count
      unit_time, to_complete = calc_remaining_time start_at, total_count, done_count, acquired_count
      unit = name.split('::').last.sub('Collector', '').downcase.pluralize
      Rails.logger.debug "#{done_count} #{unit} were collected. #{unit_time.floor}s per SPARQL. It will be completed in #{(to_complete / 3600).floor}h #{((to_complete % 3600) / 60).floor}m #{(to_complete % 60).floor}s."
    end

    def calc_remaining_time start_at, total_count, done_count, acquired_count
      unit_time = Time.now - start_at
      return [unit_time, 0] if acquired_count.zero?

      to_complete = (total_count - done_count) / acquired_count * unit_time

      [unit_time, to_complete]
    end
  end
end
