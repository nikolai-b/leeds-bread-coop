describe CollectionPoint do
  it 'is only valid Wed or Fri' do
    subject.valid_days = [3]
    expect(subject.valid?).to be_truthy

    subject.valid_days = [4]
    expect(subject.valid?).to be_falsey
  end

  it 'normalizes valid_days' do
    subject.update valid_days: ['3', '', 5]
    expect(subject.valid_days).to eq([3, 5])
  end

  it 'normalizes valid_days' do
    subject.update valid_days: [3,5]
    expect(subject.valid_day_names).to eq('Wed, Fri')
  end
end
