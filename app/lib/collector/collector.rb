# frozen_string_literal: true
module Collector
  module Collector
    DEFAULT_OFFSET_SIZE = 10_000

    def count end_point, options = nil
      r = SPARQL.get_as_json end_point, sparql_to_count(options)
      r[0]&.dig('count', 'value').to_i
    end

    def get end_point, initial_offset: 0 , total_count: 0, **options, &block
      total_count = get_total end_point, total_count, options
      get_all end_point, initial_offset, total_count, options, &block
    end

    private

    def get_total end_point, total_count, option
      total_count ||= count end_point
      Rails.logger.debug "total #{total_count}"

      total_count
    end

    def get_all end_point, initial_offset, total_count, options, &block
      offset_size = DEFAULT_OFFSET_SIZE
      done_count = initial_offset
      loop do
        start_at = Time.now

        # Adjust the offset value according to the number of actually taken.
        done_count, offset_size = get_a_part end_point, done_count, offset_size, options, &block

        show_plan_to_complete start_at, total_count, done_count, offset_size

        break if done_count >= total_count
      end
    end

    def show_plan_to_complete start_at, total_count, done_count, acquired_count
      unit_time, to_complete = calc_remaining_time start_at, total_count, done_count, acquired_count
      unit = self.name.split('::').last.sub('Collector', '').downcase.pluralize
      Rails.logger.debug "#{done_count} #{unit} were collected. #{unit_time.floor}s per SPARQL. It will be completed in #{(to_complete / 3600).floor}h #{((to_complete % 3600) / 60).floor}m #{(to_complete % 60).floor}s."
      # rubocop:enable Metrics/LineLength
    end

    def calc_remaining_time start_at, total_count, done_count, acquired_count
      unit_time = Time.now - start_at
      return [unit_time, 0] if acquired_count == 0

      to_complete = (total_count - done_count) / acquired_count * unit_time

      [unit_time, to_complete]
    end

    def get_a_part end_point, done_count, offset_size, options
      labels = get_part end_point, done_count, offset_size, options
      yield labels

      [done_count + labels.count, labels.count]
    end
  end
end
