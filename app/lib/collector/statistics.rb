# frozen_string_literal: true

module Collector
  class Statistics
    def initialize type, duration, total_count, done_count, acquired_count
      @type = type
      @start_at = duration[:start_at]
      @end_at = duration[:end_at]
      @total_count = total_count
      @done_count = done_count
      @acquired_count = acquired_count
    end

    def calc_remaining_time now = Time.zone.now
      unit_time = now - @start_at
      return [unit_time, 0] if @acquired_count.zero?

      to_complete = (@total_count - @done_count) / @acquired_count * unit_time

      [unit_time, to_complete]
    end

    def to_s
      unit = @type.pluralize
      now = Time.zone.now
      unit_time, to_complete = calc_remaining_time now
      [
        "#{@done_count} #{unit} were collected.",
        "#{(@end_at - @start_at).floor(2)}s per SPARQL.",
        "#{(now - @end_at).floor(2)}s after SPARQL.",
        "#{unit_time.floor(2)}s per request.",
        "It will be completed in #{(to_complete / 3600).floor}h #{((to_complete % 3600) / 60).floor}m #{(to_complete % 60).floor}s."
      ].join(' ')
    end
  end
end
