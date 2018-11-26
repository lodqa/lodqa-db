# frozen_string_literal: true

class Label < ActiveRecord::Base
  def self.append target_name, labels
    transaction do
      labels.each do |label, url|
        where(target_name: target_name,
              label: label,
              url: url)
          .first_or_create
      end
    end
  end
end
