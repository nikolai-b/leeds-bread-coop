class DeliveryReport
  attr_reader :date
  def initialize(date = Date.current)
    @date = date
  end

  def show
    CollectionPoint.find_each.map do |collection_point|
      collection_point.subscribers.delivery_day(@date)
    end
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["Drop-off", "Name", "Bread"]
      show.try(:each) do |delivery|
        next unless delivery.any?

        csv << [delivery[0].collection_point.name, nil, nil]

        delivery.each do |subscriber|
          subscriber.paid_bread_subs.try(:each) do |bread_type|
            csv << [nil, subscriber.name, bread_type.name]
          end
        end
      end
    end
  end

end
