# frozen_string_literal: true

class LexicalIndexJob < ActiveJob::Base
  queue_as :default

  def perform target
    job = Job.for_lexical_index_job(target.name).first
    job.run!

    Collector::LabelCollector.get target.endpoint_url do |labels|
      Label.append target.name, labels
    end

    Collector::KlassCollector.get target.endpoint_url,
                                  sortal_predicates: target.sortal_predicates do |klasses|
      Klass.append target.name, klasses
    end

    Collector::PredicateCollector.get target.endpoint_url,
                                      ignore_predicates: target.ignore_predicates do |predicate|
      Predicate.append target.name, predicate
    end

    job.finish!
  rescue StandardError => e
    bc = ActiveSupport::BacktraceCleaner.new
    bc.add_silencer { |line| line =~ /webrick|gems/ }
    logger.debug message: e.message,
                 class: e.class.to_s,
                 trace: bc.clean(e.backtrace)
    Job.abort_lexical_index_job! target.name, e
  end
end