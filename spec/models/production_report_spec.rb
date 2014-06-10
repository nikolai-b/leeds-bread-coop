describe ProductionReport do
  subject { ProductionReport.new(today) }

  describe '#show' do
    let(:today) { Date.today.next_week }

    before do
      yeast_bread = create :yeast_bread
      sour_bread = create :bread_type
      (1..3).each do |add|
        subscriber_yeast = create(:subscriber, :paid, collection_day: (1 + add) )
        create :subscriber_item, subscriber: subscriber_yeast, bread_type: yeast_bread
        subscriber = create(:subscriber, :paid, collection_day: (1 + add), num_paid_subs: 2 )
        create :subscriber_item, subscriber: subscriber, bread_type: sour_bread
        create :subscriber_item, subscriber: subscriber, bread_type: sour_bread
      end
    end

    it 'production has all breads for tomorrow (n+1)' do
      expect(subject.production.size).to eq(2)
      expect(subject.production[0].num).to eq(1)
      expect(subject.production[1].num).to eq(2)
    end

    it 'pre-prduction has all sour dough breads for (n+2)' do
      expect(subject.preproduction.size).to eq(1)
      expect(subject.preproduction[0].num).to eq(2)
    end

    it 'ferment has all sour dough for (n+3) and yeast for (n+2)' do
      expect(subject.ferment.size).to eq(2)
      expect(subject.ferment[0].num).to eq(1)
      expect(subject.ferment[1].num).to eq(2)
    end
  end
end

