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
      ursula = Subscriber.find_by(email: "ursula@example.com")
      rachel = Subscriber.find_by(email: "rachel@example.com")

      expect(ursula.bread_types[0].name).to eq('100% Rye')
      expect(ursula.collection_point.name).to eq('Green Action')
      expect(ursula.collection_day_name).to eq('Wednesday')

      expect(rachel.bread_types[0].name).to eq('Special')
      expect(rachel.collection_point.name).to eq('Fabrication')
      expect(rachel.collection_day_name).to eq('Friday')
    end
  end

  describe "#paid_bread_subs" do
    subject { create(:subscriber, :paid) }

    before do
      3.times {create :subscriber_item, subscriber: subject}
    end

    it "limits the bread_types to the num paid subs" do
      expect(subject.paid_bread_subs.size).to eq(1)
    end
  end

  describe 'update_collection_day_check' do
    let(:collection_day_updated_at) { Date.parse('2014-06-01') }
    before do
      subject.update_attribute(:collection_day_updated_at, collection_day_updated_at )
    end

    context 'with no changes'  do
      it 'collection_day_updated_at remains unchanged' do
        expect(subject.collection_day_updated_at).to eq(collection_day_updated_at)
      end
    end

    context 'with changes to collection_day' do
      before do
        subject.update({collection_day: 4})
      end

      it 'then collection_day_updated_at changes' do
        expect(subject.collection_day_updated_at).to eq(Date.today)
      end
    end

    context 'with changes to the bread type name' do
      before do
        subject.update("subscriber_items_attributes"=>{"1402307812703"=>{"bread_type_id"=>"2", "_destroy"=>"false"}})
      end

      it 'then collection_day_updated_at changes' do
        expect(subject.collection_day_updated_at).to eq(Date.today)
      end
    end
  end
end
