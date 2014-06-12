describe DeliveryReport do
  subject { DeliveryReport.new(date) }
  let(:collection_point) { create :collection_point }

  before do
    4.times {
      subscriber = create(:subscriber, collection_point: collection_point)
      create :subscriber_item, subscriber: subscriber
    }
    unpaid_subscriber = create :subscriber, name: 'NotPaid', collection_point: collection_point
    create :subscriber_item, subscriber: unpaid_subscriber, paid: false
  end

  describe '#show' do

    context 'on Friday' do
      let(:date) { Date.today.next_week.advance(days: 4) }

      it "returns an array with size of delivaries" do
        expect(subject.show[0].items.size).to eq(4)
      end

      it "each delivery has the collection point, bread_type, and subscriber name" do
        first_delivery = subject.show[0]
        first_delivery_first_item = first_delivery.items[0]

        expect(first_delivery.collection_point.name).to eq('Green Action')
        expect(first_delivery_first_item.subscriber.name).to include('Lizzie')
        expect(first_delivery_first_item.bread_type.name).to eq('White sour')
      end

      it 'excludes subscriber who have not paid' do
        names = subject.show[0].items.map { |items| items.subscriber.name }

        expect(names).not_to include('NotPaid')
        expect(names).to include('Lizzie')
      end
    end
  end

  describe '#to_csv' do

    context 'on Friday' do
      let(:date) { Date.today.next_week.advance(days: 4) }

      it "outputs a csv with subscriber info" do
        csv = CSV.parse(subject.to_csv)
        expect(csv[2]).to eq([nil, "Lizzie", "White sour"])
      end

      context 'a subscriber with more bread_types than paid subs' do
        before do
          subscriber = Subscriber.last
          bread_type = create :bread_type, name: '100% Rye'
          create :subscriber_item, bread_type: bread_type, paid: false
        end

        it "doesn't show the unpaid breads" do
          expect(subject.to_csv).to_not include('100% Rye')
        end
      end
    end
  end
end
