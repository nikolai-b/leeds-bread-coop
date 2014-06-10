class ProductionReport
  attr_reader :date

  def initialize(date = Date.current)
    @date = date
  end

  def production
    BreadType.all.each.map do |bread_type|
      num_of_bread = Subscriber.delivery_day(@date + 1.days).find_each.inject(0) do |sum, subscriber|
        sum + subscriber.paid_bread_subs.where(id: bread_type.id).count
      end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  def preproduction
    BreadType.where(sour_dough: true).each.map do |bread_type|
      num_of_bread = Subscriber.delivery_day(@date + 2.days).find_each.inject(0) do |sum, subscriber|
        sum + subscriber.paid_bread_subs.where(id: bread_type.id).count
      end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  def ferment
    BreadType.all.each.map do |bread_type|
      num_of_bread = if bread_type.sour_dough
                       Subscriber.delivery_day(@date + 3.days).find_each.inject(0) do |sum, subscriber|
                         sum + subscriber.paid_bread_subs.where(id: bread_type.id).count
                       end
                     else
                       Subscriber.delivery_day(@date + 2.days).find_each.inject(0) do |sum, subscriber|
                         sum + subscriber.paid_bread_subs.where(id: bread_type.id).count
                       end
                     end
      BreadProduction.new(name: bread_type.name, num: num_of_bread)
    end
  end

  private

  class BreadProduction
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :num, Integer
    end
  end
end
