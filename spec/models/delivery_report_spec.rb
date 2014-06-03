describe DeliveryReport do
  subject { DeliveryReport.new(date) }

  describe '#show' do
    before do
      4.times {create(:subscriber, :paid)}
      create(:subscriber, :paid, has_active_sub: false, name: 'NotPaid')
    end

    context 'on Friday' do
      let(:date) { Date.parse("2014-06-06") }

      it "returns an array with size of delivaries" do
        expect(subject.show.select{ |s| s.any? }.size).to eq(4)
      end

      it "each delivery has the collection point, bread_type, and subscriber name" do
        first_delivery = subject.show[0]

        expect(first_delivery[0].collection_point.name).to eq('Green Action')
        expect(first_delivery[0].name).to include('Lizzie')
        expect(first_delivery[0].bread_type.name).to eq('Rye Sour Loaf')
      end

      it 'excludes subscriber who have not paid' do
        names = subject.show.map { |delivery| delivery[0].try(:name) }

        expect(names).not_to include('NotPaid')
        expect(names).to include('Lizzie')
      end
    end
  end
end
