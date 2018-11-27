# frozen_string_literal: true

require_relative 'collector.rb'
require_relative 'sparql.rb'

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

      def get_part endpoint_url, offset, limit, options
        sparql = sparql_to_get offset, limit, options
        r = SPARQL.get_as_json endpoint_url, sparql
        r.map { |b| b.dig 'c', 'value' }
      end

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
    end
  end
end
