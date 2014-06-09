describe ProductionReport do
  subject { ProductionReport.new(today) }

  describe '#show' do
    let(:today) { Date.today.next_week }

    before do
      yeast_bread = create :yeast_bread
      (1..3).each do |add|
        subscriber_yeast = create(:subscriber, :paid, collection_day: (1 + add) )
        create :subscriber_item, subscriber: subscriber_yeast, bread_type: yeast_bread
        subscriber = create(:subscriber, :paid, collection_day: (1 + add) )
        create :subscriber_item, subscriber: subscriber
      end
    end

    it 'production has all breads for tomorrow (n+1)' do
      expect(subject.production.select{ |p| p.any? }.size ).to eq(2)
    end

    it 'pre-prduction has all sour dough breads for (n+2)' do
      expect(subject.preproduction.select{ |pp| pp.any? }.size).to eq(1)
    end

    it 'ferment has all sour dough for (n+3) and yeast for (n+2)' do
      expect(subject.ferment.select{ |f| f.any? }.size).to eq(2)
    end
  end
end

