class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :bread_type
  scope :ordered, -> { includes(:bread_type).order('bread_types.name').references(:bread_type) }
end
