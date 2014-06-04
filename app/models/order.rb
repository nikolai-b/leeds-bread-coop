class Order < ActiveRecord::Base
  belongs_to :wholesale_customer
  has_many :line_items
  accepts_nested_attributes_for :line_items, allow_destroy: true
  has_many :bread_types, through: :line_items
end
