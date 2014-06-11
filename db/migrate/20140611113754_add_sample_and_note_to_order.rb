class AddSampleAndNoteToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :sample, :boolean
    add_column :orders, :note, :text
  end
end
