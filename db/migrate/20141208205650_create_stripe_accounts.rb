class CreateStripeAccounts < ActiveRecord::Migration
  def change
    create_table :stripe_accounts do |t|
      t.string :customer_id
      t.references :subscriber, index: true
      t.integer :last4
      t.integer :exp_month
      t.integer :exp_year

      t.timestamps
    end
    add_index :stripe_accounts, :customer_id, unique: true
  end
end
