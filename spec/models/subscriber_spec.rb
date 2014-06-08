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
    it do
      pending
    end
  end
end
