class DeliveryReport
  attr_reader :date
  def initialize(date = Date.current)
    @date = date
  end

  def show
    collection_points = CollectionPoint.includes(subscribers: {subscriber_items: :bread_type})

    collection_points.map do |collection_point|
      deliverys_at_collection_point = collection_point.subscribers.flat_map do |subscriber|
        subscriber.subscriber_items.where(paid: true).delivery_day(@date).map do |sub_item|
          BreadDeliveryItem.new(subscriber: subscriber, bread_type: sub_item.bread_type)
        end.compact
      end
      BreadDelivery.new(collection_point: collection_point, items: deliverys_at_collection_point)
    end
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["Drop-off", "Name", "Bread"]
      show.try(:each) do |delivery|
        csv << [delivery.collection_point.name, nil, nil]

        delivery.items.each do |item|
          csv << [nil, item.subscriber.name, item.bread_type.name]
        end
      end
    end
  end

  private

  class BreadDeliveryItem
    include Virtus.value_object

    values do
      attribute :subscriber
      attribute :bread_type
    end
  end

  class BreadDelivery
    include Virtus.value_object

    values do
      attribute :collection_point
      attribute :items, Array
    end
  end
end
