#encoding: utf-8

class Payment < ActiveRecord::Base
  acts_as_paranoid

  default_scope { where(:user_id => User.current.id) }

  self.primary_key = 'uid'
  has_uid '', 24

  belongs_to :card
  belongs_to :user

  before_validation :find_out_payment_status, except: :create
  before_create :default_status
  before_save :assign_user

  STATUSES = %w(paid failed pending)

  validates_presence_of :card_id, message: 'missing_field'
  validates :amount,
            presence: true,
            numericality: {only_integer: true, greater_than_or_equal_to: 0}, :on => :create
  validates_presence_of :status, message: 'missing_field'

  validate :status_must_be_valid
  validate :check_if_limit_exceeded

  def status_must_be_valid
    self.status = 'error' unless STATUSES.include?(self.status)
    if self.status && !STATUSES.include?(self.status)
      errors.add(:status, 'Invalid status.')
    end
  end

  def check_if_limit_exceeded
    if self.card.available_limit < self.amount
      errors.add(:amount, "This payment exceeds the available limit (R$ #{(self.card.available_limit.to_f/100).round(2)}).")
    end
  end

  def assign_user
    self.user_id = User.current.id
  end

  def find_out_payment_status
    self.status = 'pending' unless STATUSES.include?(self.status)
  end

  def default_status
    self.status = 'pending'
  end

end