class DeliveryReport
  attr_reader :date
  def initialize(date = Date.current)
    @date = date
  end

  def show
    CollectionPoint.find_each.map do |collection_point|
      collection_point.subscribers.where("TO_CHAR(start_date,'D') = ?", (@date + 1.day).strftime("%w")) # %w has Sun at 0, Postgres frm D has Sun as 1
    end
  end
end
