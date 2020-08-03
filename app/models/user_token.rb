#encoding: utf-8

class UserToken < ActiveRecord::Base

  TTL = 1.years

  belongs_to :user

  before_create do |user_token|
    self.token = generate_authentication_token
  end

  private

  def generate_authentication_token
    loop do
      token = SecureRandom.hex
      break token unless UserToken.exists?(token: token)
    end
  end


end
