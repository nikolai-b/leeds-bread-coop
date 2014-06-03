class ProductionReport
  attr_reader :date

  def initialize(date = Date.current)
    @date = date
  end

  def production
    BreadType.find_each.map do |bread_type|
      bread_type.subscribers.active_sub.delivery_day(@date + 1.day)
    end
  end

  def preproduction
    BreadType.where(sour_dough: true).find_each.map do |bread_type|
      bread_type.subscribers.active_sub.delivery_day(@date + 2.days)
    end
  end

  def ferment
    BreadType.find_each.map do |bread_type|
      if bread_type.sour_dough
        bread_type.subscribers.active_sub.delivery_day(@date + 3.days)
      else
        bread_type.subscribers.active_sub.delivery_day(@date + 2.days)
      end
    end
  end
end
