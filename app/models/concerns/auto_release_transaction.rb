# frozen_string_literal: true

# Extend subclasses of the ActiveRecord::Base and add automatic release of connection to the transaction method.
module AutoReleaseTransaction
  extend ActiveSupport::Concern

  included do
    class << self
      alias_method :orig_transaction, :transaction
      def transaction options = {}, &block
        # Disable SQL log to reduce connection use time
        orig_logger = ActiveRecord::Base.logger
        begin
          ActiveRecord::Base.logger = nil
          orig_transaction(options, &block)
        ensure
          ActiveRecord::Base.logger = orig_logger
        end
      ensure
        connection_pool.checkin connection
      end
    end
  end
end
