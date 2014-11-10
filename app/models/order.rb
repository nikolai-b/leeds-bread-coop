class Order < ActiveRecord::Base
  belongs_to :wholesale_customer
  has_many :line_items
  accepts_nested_attributes_for :line_items, allow_destroy: true
  has_many :bread_types, through: :line_items
  scope :future, -> { where('date >= ?', Date.today) }

  def self.copy_regular_orders
    includes(:line_items).where(regular: true).where(date: Date.today..(Date.today + 6.days) ).each do |order|
      new_order = Order.create(
        wholesale_customer_id: order.wholesale_customer_id,
        date: (order.date + 21.days),
        regular: true,
        note: order.note
      )
      order.line_items.each do |line_item|
        new_order.line_items.create(bread_type_id: line_item.bread_type_id, quantity: line_item.quantity)
      end
    end
  end

end
