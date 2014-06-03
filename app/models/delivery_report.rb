class DeliveryReport
  attr_reader :date
  def initialize(date = Date.current)
    @date = date
  end

  def show
    CollectionPoint.find_each.map do |collection_point|
      collection_point.subscribers.active_sub.delivery_day(@date)
    end
  end
end
