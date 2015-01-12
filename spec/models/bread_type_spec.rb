describe BreadType do
  it 'has ordered scope' do
    create :bread_type
    expect(described_class.ordered.size).to eq(1)
  end
end
