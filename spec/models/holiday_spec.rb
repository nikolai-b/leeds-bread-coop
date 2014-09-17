describe Holiday do
  let(:subscriber) { create :subscriber, :with_subscription }
  let(:valid_start_date) { Date.tomorrow.beginning_of_week.next_week }
  subject { create :holiday, subscriber: subscriber }

  it 'works out number of missed subscriptions' do
    expect(subject.will_miss).to eq(2)
  end

  it 'will not allow overlapping holidays' do
    subject
    expect(subject.errors).to be_empty
    overlapping = Holiday.create( start_date: (subject.end_date - 1.day), end_date: (subject.end_date + 1.day), subscriber_id: subscriber.id )
    expect(overlapping.errors.to_a.first).to eq('Start date overlaps another holiday')
  end

  it 'should not allow holidays in the next 3 days' do
    too_close = build :holiday, start_date: Date.today
    expect(too_close.valid?).to be_falsey
    expect(too_close.errors.to_a.first).to eq('Start date is too close and your bread has been started')
  end

  it 'validates start is in the future' do
    in_past = build :holiday, start_date: Date.yesterday
    expect(in_past.valid?).to be_falsey
    expect(in_past.errors.to_a.first).to eq('Start date is in the past')
  end

  it 'validates end date is after start date' do
    end_before_start = build :holiday, end_date: (Date.today + 5.days)
    expect(end_before_start.valid?).to be_falsey
    expect(end_before_start.errors.to_a.first).to eq('End date must be after start date')
  end
end
