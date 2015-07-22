describe WholesaleCustomer do
  it 'has ordered scope' do
    create :wholesale_customer
    expect(described_class.ordered.size).to eq(1)
  end

  it { is_expected.to validate_inclusion_of(:invoice_type_id).in_array((1..4).to_a) }

  it 'has a invoice type' do
    expect(subject.invoice_type).to be_nil
    subject.invoice_type_id = 1
    expect(subject.invoice_type).to eq('Monthly')
  end
end
