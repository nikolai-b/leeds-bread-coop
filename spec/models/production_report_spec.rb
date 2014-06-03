describe ProductionReport do
  subject { ProductionReport.new(today) }

  describe '#show' do
    let(:today) { Date.parse('2014-06-02') }

    before do
      yeast_bread = create :yeast_bread
      (1..3).each do |add|
        create(:subscriber, :paid, bread_type: yeast_bread, start_date: (today + add.days) )
        create(:subscriber, :paid, start_date: (today + add.days) )
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

