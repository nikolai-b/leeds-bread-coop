describe EmailTemplate do
  it 'has ordered scope' do
    create :email_template
    expect(described_class.ordered.size).to eq(1)
  end
end
