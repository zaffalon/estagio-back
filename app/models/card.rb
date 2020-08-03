#encoding: utf-8

class Card < ActiveRecord::Base
  acts_as_paranoid

  default_scope { where(:user_id => User.current.id) }

  self.primary_key = 'uid'
  has_uid '', 24


  has_many :payments, dependent: :destroy
  belongs_to :user
  attr_accessor :cvv


  before_validation :find_out_card_brand, on: :create
  before_save :assign_user

  BRANDS = ['visa', 'mastercard', 'dinners', 'amex', 'unknown']

  validates_presence_of :name, message: 'missing_field'
  validates_presence_of :number, message: 'missing_field'
  validates_presence_of :brand, message: 'missing_field'

  validates :exp_month,
            presence: true,
            numericality: {only_integer: true}

  validates :exp_year,
            presence: true,
            numericality: {only_integer: true}

  validates :limit,
            presence: true,
            numericality: {only_integer: true, greater_than_or_equal_to: 0}

  validate :exp_month_must_be_valid
  validate :exp_year_must_be_valid

  def find_out_card_brand
    self.brand = 'unknown' unless BRANDS.include?(self.brand)
  end

  def assign_user
    self.user_id = User.current.id
  end

  def exp_month_must_be_valid
    if self.exp_month
      # return errors.add(:exp_month, 'Expiry month must be an integer') unless self.exp_month.is_a? Integer
      return errors.add(:exp_month, 'invalid_expiry_month') unless self.exp_month.to_i >= 1 && self.exp_month.to_i <= 12

      if self.exp_year
        errors.add(:exp_month, 'invalid_expiry_month') if self.exp_year.to_i == Date.current.year && self.exp_month.to_i < Date.current.month
      end
    end
  end

  def exp_year_must_be_valid
    if self.exp_year
      # return errors.add(:exp_year, 'Expiry year must be an integer') unless self.exp_year.is_a? Integer
      return errors.add(:exp_year, 'invalid_expiry_year') unless self.exp_year.to_i >= Date.current.year
    end
  end

  def available_limit
    self.limit - self.payments.sum(:amount)
  end

end
