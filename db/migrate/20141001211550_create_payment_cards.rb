class CreatePaymentCards < ActiveRecord::Migration
  def change
    create_table :payment_cards do |t|
      t.references :subscriber, index: true
      t.integer :exp_month
      t.integer :exp_year
      t.integer :last4

      t.timestamps
    end
  end
end
