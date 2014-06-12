class ProductionReport
  attr_reader :date

  def initialize(date = Date.current)
    @date = date
  end

  def production
    bread_type.map do |bread_type|
      BreadProduction.new(name: bread_type.name, num: count_paid_subscriptions(bread_type, 1))
    end
  end

  def preproduction
    bread_type.where(sour_dough: true).map do |bread_type|
      BreadProduction.new(name: bread_type.name, num: count_paid_subscriptions(bread_type, 2))
    end
  end

  def ferment
    bread_type.map do |bread_type|
      num_of_bread = if bread_type.sour_dough
                       count_paid_subscriptions(bread_type, 3)
                     else
                       count_paid_subscriptions(bread_type, 2)
                     end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  private

  def count_paid_subscriptions(bread_type, days_in_future)
    subscribers.
      where('subscriber_items.collection_day = ?', @date.wday + days_in_future).
      where('subscriber_items.bread_type_id = ?', bread_type.id).
      where('subscriber_items.paid = ?', true).
      inject(0) do |sum, subscriber|
        sum + subscriber.subscriber_items.
          where('collection_day = ?', @date.wday + days_in_future).
          where('bread_type_id = ?', bread_type.id).
          where('paid = ?', true).
          count
      end
  end

  def bread_type
    @bread_types ||= BreadType.all
  end

  def subscribers
    @subscribers ||= Subscriber.includes(:subscriber_items).references(:subscriber_items)
  end

  class BreadProduction
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :num, Integer
    end
  end
end
