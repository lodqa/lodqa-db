# frozen_string_literal: true

module AcquiredCount
  extend ActiveSupport::Concern

  class_methods do
    def acquired_count target_name
      transaction { where(target_name:).count }
    end
  end
end
