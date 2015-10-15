class Product < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 2 }

  has_many :reviews
  has_many :images
end
