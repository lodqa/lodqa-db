# frozen_string_literal: true

require_relative 'collector'

# Module to collect labels
module Collector
  module KlassCollector
    extend Collector

    SORTAL_PREDICATES = %w[
      http://www.w3.org/1999/02/22-rdf-syntax-ns#type
      http://www.w3.org/2000/01/rdf-schema#subClassOf
    ].freeze

    class << self
      private

      def sparql_to_count options
        sortal_predicates = sortal_predicates_from options

        <<~"SPARQL"
          SELECT (count(*) as ?count) {
            SELECT distinct ?c
            WHERE {
              #{sortal_predicates.map { |p| "{?x <#{p}> ?c}" }.join(" UNION\n")}
            }
          }
        SPARQL
      end

      def sparql_to_get offset, limit, options
        sortal_predicates = sortal_predicates_from options

        <<~"SPARQL"
          SELECT distinct ?c
          WHERE {
            #{sortal_predicates.map { |p| "{?x <#{p}> ?c}" }.join(" UNION\n")}
          }
          OFFSET #{offset}
          LIMIT #{limit}
        SPARQL
      end

      def sortal_predicates_from options
        return SORTAL_PREDICATES unless options&.[](:sortal_predicates)&.any?

        options&.[](:sortal_predicates)
      end

      def converter
        ->(b) { b.dig 'c', 'value' }
      end
    end
  end
end
