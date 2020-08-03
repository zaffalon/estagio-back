class PaymentSerializer < ActiveModel::Serializer

  attributes :id, :date, :amount, :status, :card_id

  def date
    object.created_at
  end
end