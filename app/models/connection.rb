# frozen_string_literal: true

class Connection < ApplicationRecord
  include AutoReleaseTransaction
  include AcquiredCount
  include CleanGarbage

  class << self
    def append target_name, connections
      transaction do
        connections.each do |subject, object|
          where(target_name:,
                subject:,
                object:)
            .first_or_create
        end
      end
    end

    # rubocop:disable Metrics/MethodLength
    def breadth_first_traversal target_name
      sql = <<~SQL.squish
        SELECT
          L.SUBJECT,
          R.OBJECT
        FROM CONNECTIONS AS L
        INNER JOIN CONNECTIONS AS R
        ON L.TARGET_NAME = R.TARGET_NAME
          AND L.OBJECT = R.SUBJECT
        WHERE L.TARGET_NAME = ?
        UNION
        SELECT
          L.SUBJECT,
          R.SUBJECT
        FROM CONNECTIONS AS L
        INNER JOIN CONNECTIONS AS R
        ON L.TARGET_NAME = R.TARGET_NAME
          AND L.OBJECT = R.OBJECT
        WHERE L.TARGET_NAME = ?
        UNION
        SELECT
          L.OBJECT,
          R.OBJECT
        FROM CONNECTIONS AS L
        INNER JOIN CONNECTIONS AS R
        ON L.TARGET_NAME = R.TARGET_NAME
          AND L.SUBJECT = R.SUBJECT
        WHERE L.TARGET_NAME = ?
        UNION
        SELECT
          L.OBJECT,
          R.SUBJECT
        FROM CONNECTIONS AS L
        INNER JOIN CONNECTIONS AS R
        ON L.TARGET_NAME = R.TARGET_NAME
          AND L.SUBJECT = R.OBJECT
        WHERE L.TARGET_NAME = ?
        EXCEPT
        SELECT
          SUBJECT,
          OBJECT
        FROM CONNECTIONS
        WHERE TARGET_NAME = ?
        EXCEPT
        SELECT
          OBJECT,
          SUBJECT
        FROM CONNECTIONS
        WHERE TARGET_NAME = ?
      SQL

      connection.select_all sanitize_sql_array [
        sql,
        target_name,
        target_name,
        target_name,
        target_name,
        target_name,
        target_name
      ]
    end
    # rubocop:enable Metrics/MethodLength
  end
end
