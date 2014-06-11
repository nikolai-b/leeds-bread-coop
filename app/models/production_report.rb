class ProductionReport
  attr_reader :date

  def initialize(date = Date.current)
    @date = date
  end

  def production
    bread_type.map do |bread_type|
      num_of_bread = subscribers.inject(0) do |sum, subscriber|
        sum + subscriber.paid_sub_items.delivery_day(@date + 1.days).where(bread_type_id: bread_type.id).count
      end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  def preproduction
    bread_type.where(sour_dough: true).map do |bread_type|
      num_of_bread = subscribers.inject(0) do |sum, subscriber|
        sum + subscriber.paid_sub_items.delivery_day(@date + 2.days).where(bread_type_id: bread_type.id).count
      end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  def ferment
    bread_type.map do |bread_type|
      num_of_bread = if bread_type.sour_dough
                       subscribers.inject(0) do |sum, subscriber|
                         sum + subscriber.paid_sub_items.delivery_day(@date + 3.days).where(bread_type_id: bread_type.id).count
                       end
                     else
                       subscribers.inject(0) do |sum, subscriber|
                         sum + subscriber.paid_sub_items.delivery_day(@date + 2.days).where(bread_type_id: bread_type.id).count
                       end
                     end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  private

  def bread_type
    @bread_types ||= BreadType.all #includes(subscribers: :subscriber_items)
  end

  def subscribers
    @subscribers ||= Subscriber.includes(subscriber_items: :bread_type)
  end

  class BreadProduction
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :num, Integer
    end
  end
end
