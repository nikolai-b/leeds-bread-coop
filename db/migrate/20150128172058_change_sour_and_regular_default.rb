class ChangeSourAndRegularDefault < ActiveRecord::Migration
  def change
    change_column_default :orders, :regular, true
    change_column_default :bread_types, :sour_dough, false
  end
end
