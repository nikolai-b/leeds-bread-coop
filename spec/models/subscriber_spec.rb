require 'spec_helper'

describe Subscriber do
  subject { create :subscriber }

  describe "#import" do
    before do
      load 'db/seeds.rb'
    end

    it "adds subscribers (inc. accociations)" do
      params_file = double('params_file').tap {|pf| pf.stub(:path).and_return('data/subscriber_import.csv')}
      Subscriber.import( params_file )
      ursula = Subscriber.find_by(email: "ursula@test.com")
      rachel = Subscriber.find_by(email: "rachel@test.com")

      expect(ursula.bread_types[0].name).to eq('100% Rye')
      expect(ursula.collection_point.name).to eq('Green Action')
      expect(ursula.subscriber_items[0].collection_day_name).to eq('Wednesday')

      expect(rachel.bread_types[0].name).to eq('Special')
      expect(rachel.collection_point.name).to eq('Fabrication')
      expect(rachel.subscriber_items[0].collection_day_name).to eq('Friday')
    end
  end

  context "with subscriber items" do
    subject { create(:subscriber) }

    before do
      4.times {create :subscriber_item, subscriber: subject}
      create :subscriber_item, subscriber: subject, paid: false
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
      2.times { create :subscriber_item, subscriber: subject }
    end

    it 'should return the collection days' do
      expect(subject.collection_days).to eq([5,5])
    end
  end

  describe 'active_on scope' do
    context 'with subscribers on holiday' do
      let!(:subscriber) { create :subscriber, :subscription }

      before do
        subscriber_on_holiday = create :subscriber, :subscription
        create :holiday, subscriber: subscriber_on_holiday
      end

      it 'excludes the subscribers on holiday' do
        expect(Subscriber.active_on(Date.tomorrow.beginning_of_week + 18.days).count).to eq 1
      end

      it 'excludes unpaid subscribers' do
        subscriber.subscriber_items[0].update_attribute :paid, false
        expect(Subscriber.active_on(Date.tomorrow.beginning_of_week + 18.days).count).to eq 0
      end
    end
  end
#  describe 'update_collection_day_check' do
#    let(:collection_day_updated_at) { Date.parse('2014-06-01') }
#    before do
#      subject.update_attribute(:collection_day_updated_at, collection_day_updated_at )
#    end
#
#    context 'with no changes'  do
#      it 'collection_day_updated_at remains unchanged' do
#        expect(subject.collection_day_updated_at).to eq(collection_day_updated_at)
#      end
#    end
#
#    context 'with changes to collection_day' do
#      before do
#        subject.update({collection_day: 4})
#      end
#
#      it 'then collection_day_updated_at changes' do
#        expect(subject.collection_day_updated_at).to eq(Date.today)
#      end
#    end
#
#    context 'with changes to the bread type name' do
#      before do
#        subject.update("subscriber_items_attributes"=>{"1402307812703"=>{"bread_type_id"=>"2", "_destroy"=>"false"}})
#      end
#
#      it 'then collection_day_updated_at changes' do
#        expect(subject.collection_day_updated_at).to eq(Date.today)
#      end
#    end
#  end
end
