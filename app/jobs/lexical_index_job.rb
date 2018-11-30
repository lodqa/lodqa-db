# frozen_string_literal: true

class LexicalIndexJob < ActiveJob::Base
  include Canceled
  queue_as :default

  def perform target
    request = target.lexical_index_request

    # Delete the request itself when it is canceled in the queued state
    return unless request

    request.run!

    endpoint = Collector::Endpoint.new target.endpoint_url

    Label.clean_gabage target.name
    return if canceled? request

    collect_label target, endpoint

    Klass.clean_gabage target.name
    return if canceled? request

    collect_klass target, endpoint

    Predicate.clean_gabage target.name
    return if canceled? request

    collect_predicate target, endpoint

    request.finish!
  rescue StandardError => e
    bc = ActiveSupport::BacktraceCleaner.new
    bc.add_silencer { |line| line =~ /webrick|gems/ }
    logger.debug message: e.message,
                 class: e.class.to_s,
                 trace: bc.clean(e.backtrace)
    LexicalIndexRequest.abort! target, e
  end

  private

  def collect_label target, endpoint
    Collector::LabelCollector.get endpoint do |labels, statistics|
      break if canceled? target.lexical_index_request

      Label.append target.name, labels

      Rails.logger.debug statistics
    end
  end

  def collect_klass target, endpoint
    Collector::KlassCollector.get endpoint,
                                  sortal_predicates: target.sortal_predicates do |klasses, statistics|
      break if canceled? target.lexical_index_request

      Klass.append target.name, klasses

      Rails.logger.debug statistics
    end
  end

  def collect_predicate target, endpoint
    Collector::PredicateCollector.get endpoint,
                                      ignore_predicates: target.ignore_predicates do |predicate, statistics|
      break if canceled? target.lexical_index_request

      Predicate.append target.name, predicate

      Rails.logger.debug statistics
    end
  end
end
