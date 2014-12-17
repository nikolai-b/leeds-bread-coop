class Order < ActiveRecord::Base
  belongs_to :wholesale_customer
  has_many :line_items
  accepts_nested_attributes_for :line_items, allow_destroy: true
  has_many :bread_types, through: :line_items
  scope :future, -> { where('date >= ?', Date.today) }
  scope :ordered, -> { order(date: :desc) }

  def self.copy_regular_orders
    includes(:line_items).where(regular: true).where(date: (Date.today + 14.days)..(Date.today + 20.days) ).each do |order|
      new_order = Order.create(
        wholesale_customer_id: order.wholesale_customer_id,
        date: (order.date + 7.days),
        regular: true,
        note: order.note
      )
      order.line_items.each do |line_item|
        new_order.line_items.create(bread_type_id: line_item.bread_type_id, quantity: line_item.quantity)
      end
    end
  end

end
