describe ProductionReport do
  subject { ProductionReport.new(today) }

  describe '#show' do
    let(:today) { Date.today.beginning_of_week + 21.days}

    before do
      subscriber_on_holiday = create :subscriber, :on_subscription_holiday

      yeast_bread = create :bread_type, :yeasty
      sour_bread = subscriber_on_holiday.subscriptions[0].bread_type

      [2, 4].each do |c_day|
        create :subscription, bread_type: yeast_bread, collection_day: c_day
        create :subscription, bread_type: sour_bread, collection_day: c_day
      end

      (1..3).each do |add|
        order = Order.create({ date: today + add, })
        order.line_items.create( bread_type_id: sour_bread.id, quantity: 5 )
        order.line_items.create( bread_type_id: yeast_bread.id, quantity: 20 )
      end
    end

    it 'production has all breads for tomorrow (n+1)' do
      expect(subject.production.size).to eq(2)
      subject.production.map do |bread_production|
        case bread_production.name
        when "Ciabatta"
          expect(bread_production.num).to eq(21)
        when "White Sourdough"
          expect(bread_production.num).to eq(6)
        end
      end
    end

    it 'pre-prduction has all sour dough breads for (n+2)' do
      expect(subject.preproduction.size).to eq(1)
      expect(subject.preproduction[0].num).to eq(5)
    end

    it 'ferment has all sour dough for (n+3) and yeast for (n+2)' do
      expect(subject.ferment.size).to eq(2)
      subject.ferment.map do |bread_ferment|
        case bread_ferment.name
        when "Ciabatta"
          expect(bread_ferment.num).to eq(20)
        when "White Sourdough"
          expect(bread_ferment.num).to eq(6)
        end
      end
    end
  end
end
