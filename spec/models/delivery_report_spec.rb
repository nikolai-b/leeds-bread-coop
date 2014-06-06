describe DeliveryReport do
  subject { DeliveryReport.new(date) }
  let(:collection_point) { create :collection_point }

  before do
    4.times {
      subscriber = create(:subscriber, :paid, collection_point: collection_point)
      create :subscriber_item, subscriber: subscriber
    }
    unpaid_subscriber = create :subscriber, name: 'NotPaid'
    create :subscriber_item, subscriber: unpaid_subscriber
  end

  describe '#show' do

    context 'on Friday' do
      let(:date) { Date.parse("2014-06-06") }

      it "returns an array with size of delivaries" do
        expect(subject.show[0].size).to eq(4)
      end

      it "each delivery has the collection point, bread_type, and subscriber name" do
        first_delivery = subject.show[0]

        expect(first_delivery[0].collection_point.name).to eq('Green Action')
        expect(first_delivery[0].name).to include('Lizzie')
        expect(first_delivery[0].bread_types[0].name).to eq('White sour')
      end

      it 'excludes subscriber who have not paid' do
        names = subject.show.map { |delivery| delivery[0].try(:name) }

        expect(names).not_to include('NotPaid')
        expect(names).to include('Lizzie')
      end
    end
  end

  describe '#to_csv' do

    context 'on Friday' do
      let(:date) { Date.parse("2014-06-06") }

      it "outputs a csv with subscriber info" do
        csv = CSV.parse(subject.to_csv)
        expect(csv[2]).to eq([nil, "Lizzie", "White sour"])
      end
    end
  end
end
