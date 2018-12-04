# frozen_string_literal: true

require 'net/http'
require 'json'
require_relative 'error'

# SPARQL Client
module Collector
  class Endpoint
    def initialize endpoint_url, graph_uri
      @endpoint_url = endpoint_url
      @graph_uri = graph_uri
    end

    def get_as_json sparql
      res = invoke sparql

      raise Error, "SPARQL request error URL: #{@endpoint_url}, SPARQL: #{sparql}, STATUS_CODE: #{res.code}, RESPONSE_BODY #{res.body}" unless res.is_a? Net::HTTPSuccess

      JSON.parse(res.body)['results']['bindings']
    rescue JSON::ParserError
      raise Error, "SPARQL endpoint #{@endpoint_url} does not return JSON format!"
    end

    private

    def invoke sparql
      uri = URI "#{@endpoint_url}?#{query_string_for(sparql)}"
      request = Net::HTTP::Get.new uri, 'accept' => 'application/sparql-results+json'
      http.request request
    end

    def query_string_for sparql
      parameters = {
        query: sparql,
        timeout: 60_000
      }
      parameters['default-graph-uri'] = @graph_uri unless @graph_uri.nil? || @graph_uri.empty?
      URI.encode_www_form parameters
    end

    def http
      @http ||= init_http
    end

    def init_http
      uri = URI @endpoint_url
      http = Net::HTTP.new uri.host, uri.port
      http.read_timeout = 70
      http.start
    end
  end
end
