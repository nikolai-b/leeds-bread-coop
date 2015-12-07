class WholesaleCustomer < ActiveRecord::Base
  has_many :orders
  scope :ordered, -> { order(:name) }
  class_attribute :invoice_types
  InvoiceType = Struct.new(:id, :name)

  self.invoice_types = [
    InvoiceType.new(1, 'Monthly'),
    InvoiceType.new(2, 'Weekly'),
    InvoiceType.new(3, 'Daily'),
    InvoiceType.new(4, 'Cash'),
    InvoiceType.new(5, 'Donation'),
  ].index_by(&:id).freeze

  validates :invoice_type_id, inclusion: { in: invoice_types.keys, allow_blank: true }

  def invoice_type
    invoice_types[invoice_type_id].name if invoice_type_id
  end
end
