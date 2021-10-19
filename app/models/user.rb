# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  attr_accessor :login

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, length: { minimum: 5, maximum: 20 }, uniqueness: true
  validates_format_of :username, with: /\A[a-zA-Z0-9][a-zA-Z0-9 _-]+\z/i

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['username = :value OR email = :value', { value: login }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
end
