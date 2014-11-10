describe Order do
  let!(:wholesale_customer_regular) { create :wholesale_customer, :with_regular_order }
  let!(:wholesale_customer_non_regular) { create :wholesale_customer, :with_order }

  it 'copies regular orders 3 weeks into the future' do
    described_class.copy_regular_orders
    orders = wholesale_customer_regular.reload.orders

    expect(orders.last.date).to eq (orders.first.date + 21.days)
    expect(orders.last.line_items[0].bread_type).to eq (orders.first.line_items[0].bread_type)
    expect(orders.last.line_items[0].quantity).to eq (orders.first.line_items[0].quantity)
  end

  it 'leaves non-regular orders' do
    described_class.copy_regular_orders
    orders = wholesale_customer_non_regular.reload.orders

    expect(orders.size).to eq (1)
  end

end
