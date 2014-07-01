require 'spec_helper'

describe Holiday do
  let(:subscriber) { create :subscriber }
  let(:valid_start_date) { Date.tomorrow.beginning_of_week.next_week }
  subject { create :holiday, subscriber: subscriber }

  it 'works out number of missed subscriptions' do
    expect(subject.will_miss).to eq(2)
  end

  it 'will not allow overlapping holidays' do
    subject
    overlapping = subscriber.holiday.create(
      start_date: (subject.end_date - 1.day),
      end_date: (subject.end_date + 1.day) )
    expect(overlapping.errors.to_a).to eq('Start date overlaps another holiday')
  end

  it 'should not allow holidays in the next 3 days' do
    too_close = create :holiday, start_date: Date.today
    expect(too_close.errors.to_a).to eq('Start date is too close and your bread is started')
  end

  it 'validates start is in the future' do
    in_past = create :holiday, start_date: Date.yesterday
    expect(in_past.errors.to_a).to eq('Start date is in the past')
  end

  it 'validates end date is after start date' do
    end_before_start = create :holiday, end_date: (Date.today + 5.days)
    expect(in_past.errors.to_a).to eq('End date is before start date')
  end
end
