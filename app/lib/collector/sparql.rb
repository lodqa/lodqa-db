# frozen_string_literal: true

require 'net/http'
require 'json'
require_relative 'error'

# SPARQL Client
module Collector
  module SPARQL
    class << self
      def get_as_json endpoint_url, sparql
        res = invoke endpoint_url, sparql

        raise Error, "SPARQL request error URL: #{endpoint_url}, SPARQL: #{sparql}, STATUS_CODE: #{res.code}, RESPONSE_BODY #{res.body}" unless res.is_a? Net::HTTPSuccess

        JSON.parse(res.body)['results']['bindings']
      rescue JSON::ParserError
        raise Error, "SPARQL endpoint #{endpoint_url} does not return JSON format!"
      end

      private

      def invoke endpoint_url, sparql
        query_string = URI.encode_www_form query: sparql, timeout: 60_000
        uri = URI "#{endpoint_url}?#{query_string}"
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
