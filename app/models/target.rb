# frozen_string_literal: true

class Target < ApplicationRecord
  include FriendlyId
  friendly_id :name

  belongs_to :user
  has_one :lexical_index_request, primary_key: :name, foreign_key: :target_name
  has_one :connection_index_request, primary_key: :name, foreign_key: :target_name
  has_many :label, primary_key: :name, foreign_key: :target_name
  has_many :klass, primary_key: :name, foreign_key: :target_name
  has_many :predicate, primary_key: :name, foreign_key: :target_name
  serialize :ignore_predicates, Array
  serialize :sortal_predicates, Array
  serialize :sample_queries, Array

  validates :name, presence: true
  validates :name, format: { with: /\A[a-zA-Z0-9][a-zA-Z0-9 _-]+\z/i }
  validates :endpoint_url, presence: true
  validates :dictionary_url, presence: true
  validates :name, uniqueness: true

  def editable? current_user
    if current_user.present?
      user == current_user
    else
      false
    end
  end

  def ignore_predicates_for_view
    ignore_predicates.join("\n")
  end

  def ignore_predicates_for_view= str
    self.ignore_predicates = str.split(/[\n\r\t]+/)
  end

  def sortal_predicates_for_view
    sortal_predicates.join("\n")
  end

  def sortal_predicates_for_view= str
    self.sortal_predicates = str.split(/[\n\r\t]+/)
  end

  def sample_queries_for_view
    sample_queries.join("\n")
  end

  def sample_queries_for_view= str
    self.sample_queries = str.split(/[\n\r\t]+/)
  end

  def instance_dictionary
    label.where.not(url: predicate.select('url')).where.not(url: klass.select('url'))
  end

  def class_dictionary
    label.where.not(url: predicate.select('url')).where(url: klass.select('url'))
  end

  def predicate_dictionary
    label.where(url: predicate.select('url'))
  end

  def enqueue! request_klass
    transaction do
      request = request_klass.request_of(self).first

      if request
        return false if request.alive?
      else
        request = request_klass.request_of(self).build
      end

      request.state = :queued
      request.save!
    end
  end

  def resume! request_klass
    transaction do
      request = request_klass.request_of(self).first

      return false unless request&.error?

      request.state = :queued
      request.save!
    end
  end

  # This request model may be deleted while executing the job.
  # In that case you will have to rebuild the model.
  def abort! request_klass, error
    transaction do
      request = request_klass.request_of(self).first_or_initialize
      request.error! error
    end
  end
end
