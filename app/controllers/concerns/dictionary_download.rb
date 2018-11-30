# frozen_string_literal: true

module DictionaryDownload
  include TargetNameParams
  extend ActiveSupport::Concern

  included do
    def show
      target = Target.find_by! name: target_name
      return head :forbidden unless target.user == current_user

      respond_to do |format|
        format.csv { send_data target.send("#{name}_dictionary").join("\n"), filename: "#{target.name}-#{name}-dictionary.csv" }
      end
    end

    private

    def name
      self.class.to_s.split(/(?=[A-Z])/).first.downcase
    end
  end
end
