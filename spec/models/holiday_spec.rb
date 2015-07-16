describe Holiday do
  let(:subscriber) { create :subscriber, :with_subscription }
  let(:valid_start_date) { Date.tomorrow.beginning_of_week.next_week }
  subject { create :holiday, subscriber: subscriber }

  it 'works out number of missed subscriptions' do
    expect(subject.will_miss).to eq(2)
  end

  it 'should not allow overlapping holidays' do
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

  it 'should not allow start in the past' do
    in_past = build :holiday, start_date: Date.yesterday
    expect(in_past.valid?).to be_falsey
    expect(in_past.errors.to_a.first).to eq('Start date is in the past')
  end

  it 'should not allow end date after start date' do
    end_before_start = build :holiday, end_date: (Date.today + 1.days)
    expect(end_before_start.valid?).to be_falsey
    expect(end_before_start.errors.to_a.first).to eq('End date must be after start date')
  end

  it 'has scope in_last_week' do
    hol = build :holiday, subscriber: subscriber, end_date: Date.tomorrow
    hol.save validate: false
    hol = build :holiday, subscriber: subscriber, end_date: (Date.today - 7.days)
    hol.save validate: false
    expect(described_class.in_last_week.size).to eq(0)
    hol = build :holiday, subscriber: subscriber, end_date: (Date.today - 6.days)
    hol.save validate: false
    expect(described_class.in_last_week.size).to eq(1)
  end

  describe 'save as admin' do
    it 'should not allow end date before start date' do
      end_before_start = build :holiday, end_date: (Date.today + 1.days)
      expect(end_before_start.save_as_admin).to be_falsey
    end

    it 'should allow start date in past' do
      in_past = build :holiday, start_date: Date.yesterday
      expect(in_past.save_as_admin).to be_truthy
      expect(in_past.errors_on(:start_date)).to include('is in the past')
    end

    it 'should not allow end date in past' do
      in_past = build :holiday, start_date: 1.week.ago, end_date: 1.day.ago
      expect(in_past.save_as_admin).to be_falsey
      expect(in_past.errors_on(:end_date)).to include('is in the past')
    end

    it 'should allow holidays in the next 3 days' do
      too_close = build :holiday, start_date: Date.today
      expect(too_close.save_as_admin).to be_truthy
      expect(too_close.errors_on(:start_date)).to include('is too close and your bread has been started')
    end

    it 'should not allow overlapping holidays' do
      subject
      expect(subject.errors).to be_empty
      overlapping = Holiday.create( start_date: (subject.end_date - 1.day), end_date: (subject.end_date + 1.day), subscriber_id: subscriber.id )
      expect(overlapping.errors.to_a.first).to eq('Start date overlaps another holiday')
    end
  end

end
