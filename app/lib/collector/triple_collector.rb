# frozen_string_literal: true

require_relative 'collector'

# Module to get total count of triples
module Collector
  module TripleCollector
    extend Collector

    class << self
      private

      def sparql_to_count _options
        <<~SPARQL
          SELECT (COUNT(?s) AS ?count)
          WHERE { ?s ?p ?o }
        SPARQL
      end

      def sparql_to_get _offset, _limit, _options
        raise NotImplementedError
      end

      def converter
        raise NotImplementedError
      end
    end
  end
end
