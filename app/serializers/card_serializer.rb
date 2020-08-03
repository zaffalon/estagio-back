class CardSerializer < ActiveModel::Serializer


  attributes :id, :name, :exp_month, :exp_year, :brand, :number, :limit, :available_limit

  def available_limit
    object.available_limit
  end

end