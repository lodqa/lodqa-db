# frozen_string_literal: true

class Label < ApplicationRecord
  include AutoReleaseTransaction
  include AcquiredCount
  include CleanGarbage

  def self.append target_name, labels
    transaction do
      labels.each do |label, url|
        where(target_name:,
              label:,
              url:)
          .first_or_create
      end
    end
  end

  def to_s
    "#{label}\t#{url}"
  end
end
