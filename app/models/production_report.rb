class ProductionReport
  attr_reader :date

  def initialize(date = Date.current)
    @date = date
  end

  def production
    bread_type.map do |bread_type|
      BreadProduction.new(name: bread_type.name, num: count_orders_and_subscriptions(bread_type, 1))
    end
  end

  def preproduction
    bread_type.where(sour_dough: true).map do |bread_type|
      BreadProduction.new(name: bread_type.name, num: count_orders_and_subscriptions(bread_type, 2))
    end
  end

  def ferment
    bread_type.map do |bread_type|
      num_of_bread = if bread_type.sour_dough
                       count_orders_and_subscriptions(bread_type, 3)
                     else
                       count_orders_and_subscriptions(bread_type, 2)
                     end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  private

  def count_orders_and_subscriptions(bread_type, days_in_future)
    count_paid_subscriptions(bread_type, days_in_future) + count_wholesale_orders(bread_type, days_in_future)
  end

  def count_paid_subscriptions(bread_type, days_in_future)
    Subscription.includes(subscriber: :holidays).paid_untill(@date).
          where(collection_day: (@date.wday + days_in_future)).
          where(bread_type_id: bread_type.id).
          where('subscribers.holidays_count = 0 OR DATE(?) NOT BETWEEN holidays.start_date AND holidays.end_date', @date + days_in_future).
          where('subscribers.admin = ?', false).
          references(:holidays, :subscribers).
          count
  end

  def count_wholesale_orders(bread_type, days_in_future)
    Order.all.where(date: @date + days_in_future).inject(0) do |sum, order|
      sum + order.line_items.where(bread_type_id: bread_type.id).sum(:quantity)
    end
  end


  def bread_type
    @bread_types ||= BreadType.all
  end

  class BreadProduction
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :num, Integer
    end
  end
end
