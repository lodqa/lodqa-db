# frozen_string_literal: true

module CleanGarbage
  extend ActiveSupport::Concern

  class_methods do
    def clean_gabage target_name
      transaction { where(target_name:).delete_all }
    end
  end
end
