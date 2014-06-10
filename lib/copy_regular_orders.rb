require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

class CopyRegularOrders < Struct.new(:date)
  def perform
    Order.where(regular: true).where(date: date..(date + 6.days) ).each do |order|
      new_order = Order.create(wholesale_customer_id: order.wholesale_customer_id, date: (order.date + 21.days), regular: true)
      order.line_items.each do |line_item|
        new_order.line_items.create(bread_type_id: line_item.bread_type_id, quantity: line_item.quantity)
      end
    end
  end
end

every(7.days, 'Copy regular orders') { Delayed::Job.enqueue CopyRegularOrders.new(Date.today) }
