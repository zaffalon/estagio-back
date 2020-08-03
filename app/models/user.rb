#encoding: utf-8

class User < ActiveRecord::Base

  acts_as_authentic do |c|
    # c.crypto_provider = Authlogic::CryptoProviders::Sha512

    c.validate_login_field = false
    c.validate_email_field = false
    # c.crypted_password_field = false
    c.require_password_confirmation = false
    c.ignore_blank_passwords = true
    c.validate_password_field = false
    c.check_passwords_against_database = false
    c.login_field = :token
  end

  has_many :user_tokens
  has_many :cards
  has_many :payments
  has_one :started_test

  before_create :create_token

  validates_presence_of :name, message: 'missing_field'
  validates_presence_of :email, message: 'missing_field'

  def valid_password?(password)
    true
  end

  def create_token
    self.user_tokens << UserToken.create
    # self.openid_identifier = generate_authentication_token
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.current
    Thread.current[:current_user]
  end
end
