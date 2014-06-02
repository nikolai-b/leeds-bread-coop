describe DeliveryReport do
  subject { DeliveryReport.new(date) }

  describe '#show' do
    before do
      4.times {create(:subscriber, :paid)}
    end

    context 'on Friday' do
      let(:date) { Date.parse("2014-06-06") }

      it "returns an array with size of delivaries" do
        expect(subject.show.size).to eq(4)
      end

      it "each delivary has the collection point, bread_type, and subscriber name" do
        first_delivary = subject.show[0]

        expect(first_delivary[0].collection_point.name).to eq('Green Action')
        expect(first_delivary[0].name).to include('Lizzie')
        expect(first_delivary[0].bread_type.name).to eq('Rye Sour Loaf')
      end
    end
  end
end
