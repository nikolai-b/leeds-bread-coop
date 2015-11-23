describe CollectionPoint do
  it 'is only valid Wed or Fri' do
    subject.valid_days = [2]
    expect(subject.valid?).to be_truthy

    subject.valid_days = [3]
    expect(subject.valid?).to be_falsey
  end

  it 'normalizes valid_days' do
    subject.update valid_days: ['2', '', 4]
    expect(subject.valid_days).to eq([2, 4])
  end

  it 'normalizes valid_days' do
    subject.update valid_days: [2,4]
    expect(subject.valid_day_names).to eq('Tue, Thu')
  end

  it 'has ordered scope' do
    create :collection_point
    expect(described_class.ordered.size).to eq(1)
  end
end
