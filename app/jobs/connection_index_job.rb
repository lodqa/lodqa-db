# frozen_string_literal: true

class ConnectionIndexJob < ActiveJob::Base
  queue_as :default

  def perform target
    request = target.connection_index_request

    # Delete the request itself when it is canceled in the queued state
    return unless request

    request.run!

    endpoint = Collector::Endpoint.new target.endpoint_url, target.graph_uri

    request.number_of_triples = Collector::TripleCollector.count endpoint

    Connection.clean_gabage target.name
    return if request.delete_if_canceling!

    collect_connection target, endpoint

    request.finish!
  rescue StandardError => e
    bc = ActiveSupport::BacktraceCleaner.new
    bc.add_silencer { |line| line =~ /webrick|gems/ }
    logger.debug message: e.message,
                 class: e.class.to_s,
                 trace: bc.clean(e.backtrace)
    target.abort! ConnectionIndexRequest, e
  end

  private

  def collect_connection target, endpoint
    Collector::ConnectionCollector.get endpoint do |connections, statistics|
      break if target.connection_index_request.delete_if_canceling!

      Connection.append target.name, connections

      Rails.logger.debug statistics

      target.connection_index_request.statistics = statistics
    end
  end
end
