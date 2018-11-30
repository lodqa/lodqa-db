# frozen_string_literal: true

module TargetNameParams
  extend ActiveSupport::Concern

  included do
    private

    def target_name
      params.require(:target_id)
    end
  end
end
