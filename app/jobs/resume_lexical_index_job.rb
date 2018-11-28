# frozen_string_literal: true

class ResumeLexicalIndexJob < ActiveJob::Base
  include Canceled
  queue_as :default

  def perform target
    request = target.lexical_index_request

    # Delete the request itself when it is canceled in the queued state
    return unless request

    request.run!

    endpoint = Collector::Endpoint.new target.endpoint_url

    label_acquired_count = Label.acquired_count target.name
    return if canceled? request

    Collector::LabelCollector.get endpoint,
                                  initial_offset: label_acquired_count do |labels|
      break if canceled? request

      Label.append target.name, labels
    end

    klass_acquired_count = Klass.acquired_count target.name
    return if canceled? request

    Collector::KlassCollector.get endpoint,
                                  initial_offset: klass_acquired_count,
                                  sortal_predicates: target.sortal_predicates do |klasses|
      break if canceled? request

      Klass.append target.name, klasses
    end

    predicate_acquired_count = Predicate.acquired_count target.name
    return if canceled? request

    Collector::PredicateCollector.get endpoint,
                                      initial_offset: predicate_acquired_count,
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
