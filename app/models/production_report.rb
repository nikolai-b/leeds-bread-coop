class ProductionReport

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
    ret = BreadType.where(sour_dough: false).find_each.map do |bread_type|
      bread_type.subscribers.active_sub.delivery_day(@date + 3.days)
    end

    ret << BreadType.where(sour_dough: false).find_each.map do |bread_type|
      bread_type.subscribers.active_sub.delivery_day(@date + 2.days)
    end

    ret
  end
end
