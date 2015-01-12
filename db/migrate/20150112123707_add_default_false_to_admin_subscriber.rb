class AddDefaultFalseToAdminSubscriber < ActiveRecord::Migration
  def change
    change_column_default :subscribers, :admin, false
    update "UPDATE subscribers SET admin = 'F' WHERE admin IS NULL"
  end
end
