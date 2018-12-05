# frozen_string_literal: true

class Connection < ActiveRecord::Base
  include AutoReleaseTransaction
  include AcquiredCount
  include CleanGarbage

  def self.append target_name, connections
    transaction do
      connections.each do |subject, object|
        where(target_name: target_name,
              subject: subject,
              object: object)
          .first_or_create
      end
    end
  end
end
