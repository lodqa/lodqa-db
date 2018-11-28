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

    Collector::LabelCollector.get endpoint do |labels|
      break if canceled? request

      Label.append target.name, labels
    end

    Klass.clean_gabage target.name
    return if canceled? request

    Collector::KlassCollector.get endpoint,
                                  sortal_predicates: target.sortal_predicates do |klasses|
      break if canceled? request

      Klass.append target.name, klasses
    end

    Predicate.clean_gabage target.name
    return if canceled? request

    Collector::PredicateCollector.get endpoint,
                                      ignore_predicates: target.ignore_predicates do |predicate|
      break if canceled? request

      Predicate.append target.name, predicate
    end

    request.finish!
  rescue StandardError => e
    bc = ActiveSupport::BacktraceCleaner.new
    bc.add_silencer { |line| line =~ /webrick|gems/ }
    logger.debug message: e.message,
                 class: e.class.to_s,
                 trace: bc.clean(e.backtrace)
    LexicalIndexRequest.abort! target, e
  end
end
