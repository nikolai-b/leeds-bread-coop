require 'spec_helper'

describe Subscriber do
  subject { create :subscriber }

  describe "#import" do
    before do
      load 'db/seeds.rb'
    end

    it "adds subscribers (inc. accociations)" do
      params_file = double('params_file').tap {|pf| pf.stub(:path).and_return('spec/fixtures/subscriber_import.csv')}
      described_class.import( params_file )
      ursula = described_class.find_by(email: "ursula@test.com")
      rachel = described_class.find_by(email: "rachel@test.com")

      expect(ursula.bread_types[0].name).to eq('100% Rye')
      expect(ursula.collection_point.name).to eq('Green Action')
      expect(ursula.subscriptions[0].collection_day_name).to eq('Wednesday')

      expect(rachel.bread_types[0].name).to eq('Special')
      expect(rachel.collection_point.name).to eq('Fabrication')
      expect(rachel.subscriptions[0].collection_day_name).to eq('Friday')
    end
  end

  context "with subscriber items" do
    before do
      4.times {create :subscription, subscriber: subject}
      create :subscription, subscriber: subject, paid: false
    end

    it "returns the num paid subscriber items" do
      expect(subject.num_paid_subs).to eq(4)
    end

    it "returns the num unpaid subscriber items" do
      expect(subject.num_unpaid_subs).to eq(1)
    end
  end

  describe 'collection_days' do
    before do
      2.times { create :subscription, subscriber: subject }
    end

    it 'should return the collection days' do
      expect(subject.collection_days).to eq([5,5])
    end
  end

  describe 'active_on scope' do
    context 'with subscribers on holiday' do
      let(:subscriber_other)   { create :subscriber, :with_subscription }

      before do
        create :holiday, subscriber: subscriber_other
        create :subscription, subscriber: subject
      end

      it 'excludes the subscribers on holiday' do
        expect(described_class.active_on(Date.tomorrow.beginning_of_week + 18.days).count).to eq 1
      end

      it 'excludes unpaid subscribers' do
        subject.subscriptions[0].update_attribute :paid, false
        expect(described_class.active_on(Date.tomorrow.beginning_of_week + 18.days).count).to eq 0
      end
    end
  end

  it 'has ordered scope' do
    create :subscriber, first_name: 'Aaa1', last_name: 'Zzzzz'
    create :subscriber, first_name: 'Aaa1', last_name: 'Aaaaa'
    create :subscriber, first_name: 'Zzzz', last_name: 'Aaaaa'
    expect(described_class.ordered[0].last_name).to eq('Aaaaa')
    expect(described_class.ordered[1].first_name).to eq('Aaa1')
    expect(described_class.ordered[2].first_name).to eq('Zzzz')
  end

  it 'has a monthly cost' do
    expect(subject.monthly_payment).to eq(0)
    create :subscription, subscriber: subject, paid: true
    subject.reload
    expect(subject.monthly_payment).to eq(10)
  end

end
