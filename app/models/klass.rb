class Klass < ActiveRecord::Base
  def self.append(target_name, klasses)
    transaction do
      klasses.each do |url|
        where(target_name: target_name,
              url: url)
          .first_or_create
      end
    end
  end
end
