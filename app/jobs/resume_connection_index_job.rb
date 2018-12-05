# frozen_string_literal: true

class ResumeConnectionIndexJob < ActiveJob::Base
  queue_as :default

  def perform target
    request = target.connection_index_request

    # Delete the request itself when it is canceled in the queued state
    return unless request

    request.run!

    endpoint = Collector::Endpoint.new target.endpoint_url, target.graph_uri

    now_count = Collector::TripleCollector.count endpoint
    raise 'The number of triples has been changed since the last run.' if now_count != request.number_of_triples

    connection_acquired_count = Connection.acquired_count target.name
    return if request.delete_if_canceling!

    collect_connection target, endpoint, connection_acquired_count

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

  def collect_connection target, endpoint, acquired_count
    Collector::LabelCollector.get endpoint,
                                  initial_offset: acquired_count do |connections, statistics|
      break if target.connection_index_request.delete_if_canceling!

      Connection.append target.name, connections

      Rails.logger.debug statistics

      target.connection_index_request.statistics = statistics
    end
  end
end
