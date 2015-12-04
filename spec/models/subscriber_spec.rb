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

      expect(ursula.bread_types[0].name).to eq('Vollkornbrot (100% rye)')
      expect(ursula.collection_point.name).to eq('Green Action Food Co-op')
      expect(ursula.subscriptions[0].collection_day_name).to eq('Tuesday')

      expect(rachel.bread_types[0].name).to eq('Weekly Special')
      expect(rachel.collection_point.name).to eq('Fabrication')
      expect(rachel.subscriptions[0].collection_day_name).to eq('Thursday')
    end
  end

  context "with subscriber items" do
    before do
      4.times {create :subscription, subscriber: subject}
      create :subscription, subscriber: subject, paid_till: nil
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
      expect(subject.collection_days).to eq([4,4])
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
        expect(described_class.active_on(Date.tomorrow.beginning_of_week + 17.days).count).to eq 1
      end

      it 'excludes unpaid subscribers' do
        subject.subscriptions[0].update_attribute :paid_till, Date.yesterday
        expect(described_class.active_on(Date.tomorrow.beginning_of_week + 17.days).count).to eq 0
      end
    end
  end

  it 'has ordered scope' do
    create :subscriber, first_name: 'Aaa1', last_name: 'Zzzzz'
    create :subscriber, first_name: 'Aaa1', last_name: 'Aaaaa'
    create :subscriber, first_name: 'Xyz', last_name: 'Aaaaa'
    expect(described_class.ordered[0].first_name).to eq('Aaa1')
    expect(described_class.ordered[1].first_name).to eq('Xyz')
    expect(described_class.ordered[2].last_name).to eq('Zzzzz')
  end

  it 'has pays with stripe scope' do
    create :subscriber, :with_subscription
    expect(described_class.pays_with_stripe.count).to eq(1)
  end

  it 'has pays with BACS scope' do
    create :subscriber, payment_type_id: 2
    expect(described_class.pays_with('bacs').count).to eq(1)
  end

  it 'has pays with SO scope' do
    create :subscriber, payment_type_id: 1
    expect(described_class.pays_with('so').count).to eq(1)
  end

  it 'has a search scope' do
    create :subscriber, first_name: 'FirSt', last_name: 'Last'
    create :subscriber, first_name: 'Needs', last_name: 'Space'
    expect(described_class.search('fIrsT lAsT').count).to eq(1)
    expect(described_class.search('IRs').count).to eq(1)
    expect(described_class.search('NeedsSpace').count).to eq(0)
    expect(described_class.search('Needs Space').count).to eq(1)
  end

  it 'has a monthly cost' do
    expect(subject.monthly_payment).to eq(0)
    create :subscription, subscriber: subject
    subject.reload
    expect(subject.monthly_payment).to eq(10)
  end

end
