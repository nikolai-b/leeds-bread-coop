describe ProductionReport do
  subject { ProductionReport.new(today) }

  describe '#show' do
    let(:today) { Date.today.next_week.next_week }

    before do
      subscriber_on_holiday = create :subscriber, :on_subscription_holiday

      yeast_bread = create :yeast_bread
      sour_bread = subscriber_on_holiday.subscriber_items[0].bread_type
      (1..3).each do |add|
        create :subscriber_item, bread_type: yeast_bread, collection_day: (1 + add)

        subscriber = create :subscriber
        3.times {create :subscriber_item, subscriber: subscriber, bread_type: sour_bread, collection_day: (1 + add) }

        order = Order.create({ date: today + add, })
        order.line_items.create(
          {
            bread_type_id: sour_bread.id,
            quantity: 15
          }
        )

      end


    end

    it 'production has all breads for tomorrow (n+1)' do
      expect(subject.production.size).to eq(2)
      subject.production.map do |bread_production|
        case bread_production.name
        when "Ciabatta"
          expect(bread_production.num).to eq(1)
        when "White sour"
          expect(bread_production.num).to eq(18)
        end
      end
    end

    it 'pre-prduction has all sour dough breads for (n+2)' do
      expect(subject.preproduction.size).to eq(1)
      expect(subject.preproduction[0].num).to eq(18)
    end

    it 'ferment has all sour dough for (n+3) and yeast for (n+2)' do
      expect(subject.ferment.size).to eq(2)
      subject.ferment.map do |bread_ferment|
        case bread_ferment.name
        when "Ciabatta"
          expect(bread_ferment.num).to eq(1)
        when "White sour"
          expect(bread_ferment.num).to eq(18)
        end
      end
    end
  end
end

