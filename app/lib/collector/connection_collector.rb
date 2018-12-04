# frozen_string_literal: true

require_relative 'collector.rb'

# Module to collect labels
module Collector
  module ConnectionCollector
    extend Collector

    class << self
      private

      def sparql_to_count _options
        <<~"SPARQL"
          SELECT (count(*) as ?count) {
            SELECT distinct ?s ?o
            WHERE {
              ?s ?p ?o
              FILTER isIRI(?o)
            }
            GROUP BY ?s ?o
          }
        SPARQL
      end

      def sparql_to_get offset, limit, _options
        <<~"SPARQL"
          SELECT distinct ?s ?o
          WHERE {
            ?s ?p ?o
            FILTER isIRI(?o)
          }
          GROUP BY ?s ?o
          OFFSET #{offset}
          LIMIT #{limit}
        SPARQL
      end

      def converter
        lambda { |b|
          s = b.dig 's', 'value'
          o = b.dig 'o', 'value'
          [s, o]
        }
      end
    end
  end
end
