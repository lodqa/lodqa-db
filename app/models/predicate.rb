# frozen_string_literal: true

class Predicate < ActiveRecord::Base
  include AutoReleaseTransaction
  include AcquiredCount
  include CleanGarbage

  def self.append target_name, predicates
    transaction do
      predicates.each do |url|
        where(target_name: target_name,
              url: url)
          .first_or_create
      end
    end
  end
end
