# frozen_string_literal: true

require 'net/http'
require 'json'

# SPARQL Client
module Collector
  module SPARQL
    class << self
      def get_as_json end_point, sparql
        res = invoke end_point, sparql

        raise "SPARQL request error URL: #{end_point}, SPARQL: #{sparql}, STATUS_CODE: #{res.code}, RESPONSE_BODY #{res.body}" unless res.is_a? Net::HTTPSuccess

        JSON.parse(res.body)['results']['bindings']
      end

      private

      def invoke end_point, sparql
        query_string = URI.encode_www_form query: sparql, timeout: 60_000
        uri = URI "#{end_point}?#{query_string}"
        request = Net::HTTP::Get.new uri, 'accept' => 'application/sparql-results+json'
        http(uri).request request
      end

      def http uri
        @http ||= init_http uri
      end

      def init_http uri
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = 70
        http.start
      end
    end
  end
end
