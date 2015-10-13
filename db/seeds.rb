# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Product.create(name: "Azurite", price: 110.50, description: "Some gems have hidden qualities beyond their luster, beyond their shine... Azurite is one of those gems.", canPurchase: true)

Product.create(name: "Bloodstone", price: 22.90, description: "Origin of the Bloodstone is unknown, hence its low value. It has a very high shine and 12 sides, however.", canPurchase: true)

Product.create(name: "Zircon", price: 1100.00, description: "Zircon is our most coveted and sought after gem. You will pay much to be the proud owner of this gorgeous and high shine gem.", canPurchase: true)

product_names = ["Azurite", "Bloodstone", "Zircon"]
image_urls = ["http://hijk.it/image/0t1y1l3T1226/gem-01.gif", "http://hijk.it/image/1i2z0R1g1z0Z/gem-02.gif", "http://hijk.it/image/2c3h3m0I3n1c/gem-03.gif"]

index = 0;

product_names.each do |name|
  Review.create(product: Product.find_by(name: name), stars: 5, body: "I love this product!", author: "joe@thomas.com")

  Review.create(product: Product.find_by(name: name), stars: 1, body: "This product sucks", author: "tim@hater.com")

  Image.create(product: Product.find_by(name: name), image_url: image_urls[index])

  index += 1
end
