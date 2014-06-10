namespace :orders do

  desc "Copy the regular orders from this week to two weeks in future"
  task :copy_regular  => :environment do
    Order.where(regular: true).where(date: (Date.today .. (Date.today + 6.days))).each do |order|
      new_order = Order.create(wholesale_customer_id: order.wholesale_customer_id, date: (order.date + 21.days), regular: true)
      order.line_items.each do |line_item|
        new_order.line_items.create(bread_type_id: line_item.bread_type_id, quantity: line_item.quantity)
      end
    end
  end

end
