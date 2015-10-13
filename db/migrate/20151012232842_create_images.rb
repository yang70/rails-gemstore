class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.belongs_to :product, index:true
      t.string :image_url

      t.timestamps null: false
    end
  end
end
