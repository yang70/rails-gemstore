class ProductSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :price,
             :description,
             :canPurchase

  has_many :images
  has_many :reviews
end
