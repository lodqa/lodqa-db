# frozen_string_literal: true

class ResumeLexicalIndexJob < ActiveJob::Base
  queue_as :default

  def perform target
    request = target.lexical_index_request
    request.run!

    endpoint = Collector::Endpoint.new target.endpoint_url

    Collector::LabelCollector.get endpoint,
                                  initial_offset: Label.acquired_count(target.name) do |labels|
      Label.append target.name, labels
    end

    Collector::KlassCollector.get endpoint,
                                  initial_offset: Klass.acquired_count(target.name),
                                  sortal_predicates: target.sortal_predicates do |klasses|
      Klass.append target.name, klasses
    end

    Collector::PredicateCollector.get endpoint,
                                      initial_offset: Predicate.acquired_count(target.name),
                                      ignore_predicates: target.ignore_predicates do |predicate|
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
