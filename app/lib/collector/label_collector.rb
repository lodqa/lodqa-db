# frozen_string_literal: true

require_relative 'collector.rb'

# Module to collect labels
module Collector
  class LabelCollector
    extend Collector

    LABEL_PROPERTIES = %w[
      <http://www.w3.org/2000/01/rdf-schema#label>
      <http://www.w3.org/2004/02/skos/core#prefLabel>
      <http://purl.org/dc/terms/title>
    ].freeze

    class << self
      private

      def get_part endpoint_url, offset, limit, _options
        r = SPARQL.get_as_json endpoint_url, sparql_to_get(offset, limit)
        r.map do |b|
          l = b.dig 'l', 'value'
          x = b.dig 'x', 'value'
          [l, x]
        end
      end

      def sparql_to_count _options
        <<~"SPARQL"
          SELECT (COUNT(*) AS ?count)
          WHERE {
            #{LABEL_PROPERTIES.map { |p| "{?x #{p} ?l}" }.join(" UNION\n")}
          }
        SPARQL
      end

      def sparql_to_get offset, limit
        <<~"SPARQL"
          SELECT ?l ?x
          WHERE {
            #{LABEL_PROPERTIES.map { |p| "{?x #{p} ?l}" }.join(" UNION\n")}
          }
          OFFSET #{offset}
          LIMIT #{limit}
        SPARQL
      end
    end
  end
end
