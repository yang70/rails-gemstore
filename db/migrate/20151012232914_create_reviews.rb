class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.belongs_to :product, index:true
      t.integer :stars
      t.string :body
      t.string :author

      t.timestamps null: false
    end
  end
end
