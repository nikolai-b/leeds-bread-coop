class CreateBreadTypes < ActiveRecord::Migration
  def change
    create_table :bread_types do |t|
      t.text :name
      t.boolean :sour_dough
      t.text :notes

      t.timestamps
    end
  end
end
