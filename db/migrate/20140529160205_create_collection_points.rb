class CreateCollectionPoints < ActiveRecord::Migration
  def change
    create_table :collection_points do |t|
      t.text :address
      t.text :post_code
      t.text :notes
      t.text :name

      t.timestamps
    end
  end
end
