# frozen_string_literal: true

class ResumeLexicalIndexJob < ActiveJob::Base
  queue_as :default

  def perform target
    request = target.lexical_index_request

    # Delete the request itself when it is canceled in the queued state
    return unless request

    request.run!

    endpoint = Collector::Endpoint.new target.endpoint_url, target.graph_uri

    now_count = Collector::TripleCollector.count endpoint
    raise 'The number of triples has been changed since the last run.' if now_count != request.number_of_triples

    label_acquired_count = Label.acquired_count target.name
    return if request.delete_if_canceling

    collect_label target, endpoint, label_acquired_count

    klass_acquired_count = Klass.acquired_count target.name
    return if request.delete_if_canceling

    collect_klass target, endpoint, klass_acquired_count

    predicate_acquired_count = Predicate.acquired_count target.name
    return if request.delete_if_canceling

    collect_predicate target, endpoint, predicate_acquired_count

    request.finish!
  rescue StandardError => e
    bc = ActiveSupport::BacktraceCleaner.new
    bc.add_silencer { |line| line =~ /webrick|gems/ }
    logger.debug message: e.message,
                 class: e.class.to_s,
                 trace: bc.clean(e.backtrace)
    LexicalIndexRequest.abort! target, e
  end

  def collect_label target, endpoint, acquired_count
    Collector::LabelCollector.get endpoint,
                                  initial_offset: acquired_count do |labels, statistics|
      break if target.lexical_index_request.delete_if_canceling

      Label.append target.name, labels

      Rails.logger.debug statistics

      target.lexical_index_request.statistics = statistics
    end
  end

  def collect_klass target, endpoint, acquired_count
    Collector::KlassCollector.get endpoint,
                                  initial_offset: acquired_count,
                                  sortal_predicates: target.sortal_predicates do |klasses, statistics|
      break if target.lexical_index_request.delete_if_canceling

      Klass.append target.name, klasses

      Rails.logger.debug statistics

      target.lexical_index_request.statistics = statistics
    end
  end

  def collect_predicate target, endpoint, acquired_count
    Collector::PredicateCollector.get endpoint,
                                      initial_offset: acquired_count,
                                      ignore_predicates: target.ignore_predicates do |predicate, statistics|
      break if target.lexical_index_request.delete_if_canceling

      Predicate.append target.name, predicate

      Rails.logger.debug statistics

      target.lexical_index_request.statistics = statistics
    end
  end
end
