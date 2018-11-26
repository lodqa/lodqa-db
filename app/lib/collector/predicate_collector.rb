# frozen_string_literal: true

require_relative 'collector.rb'
require_relative 'sparql.rb'

module Collector
  module PredicateCollector
    extend Collector

    IGNORE_PREDICATES = %w[
      http://www.w3.org/1999/02/22-rdf-syntax-ns#type
    ].freeze

    class << self
      private

      def get_part end_point, offset, limit, options
        r = SPARQL.get_as_json end_point, sparql_to_get(offset, limit, options)
        r.map { |b| b.dig 'p', 'value' }
      end

      # The bio2rdf does not timeout if group by clause is attached.
      # The reason is unknown, but Virtuoso uses the Group by clause to make SPARQL run faster
      def sparql_to_count options
        ignore_predicates = ignore_predicates_from options

        <<~"SPARQL"
          SELECT (count(*) as ?count) {
            SELECT distinct ?p
            WHERE {
              ?s ?p ?o
              #{ignore_predicates.map { |p| "filter (?p != <#{p}>)" }.join("\n")}
            }
            GROUP BY ?p
          }
        SPARQL
      end

      def sparql_to_get offset, limit, options
        ignore_predicates = ignore_predicates_from options

        <<~"SPARQL"
          SELECT distinct ?p
          WHERE {
            ?s ?p ?o
            #{ignore_predicates.map { |p| "filter (?p != <#{p}>)" }.join("\n")}
          }
          GROUP BY ?p
          OFFSET #{offset}
          LIMIT #{limit}
        SPARQL
      end

      def ignore_predicates_from options
        IGNORE_PREDICATES + options&.[](:ignore_predicates).to_a
      end
    end
  end
end