describe WholesaleCustomer do
  it 'has ordered scope' do
    create :wholesale_customer
    expect(described_class.ordered.size).to eq(1)
  end
end
