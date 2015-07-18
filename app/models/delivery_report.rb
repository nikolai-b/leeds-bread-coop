class DeliveryReport
  attr_reader :date
  def initialize(date = Date.current)
    @date = date
  end

  def show
    collection_points = CollectionPoint.includes(subscribers: {subscriptions: :bread_type})

    collection_points.map do |collection_point|
      deliverys_at_collection_point = collection_point.subscribers.active_on(@date).flat_map do |subscriber|
        subscriber.subscriptions.map do |sub_item|
          BreadDeliveryItem.new(subscriber: subscriber, bread_type: sub_item.bread_type)
        end.compact
      end
      BreadDelivery.new(collection_point: collection_point, items: deliverys_at_collection_point)
    end
  end

  def wholesale_show
    Order.all.where(date: @date).map do |order|
      items = order.line_items.map do |line_item|
        WholesaleDeliveryItem.new(bread_type: line_item.bread_type, quantity: line_item.quantity)
      end
      WholesaleDelivery.new(wholesale_customer: order.wholesale_customer, items: items, order: order)
    end
  end

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["Wholesale Customer", "Order Notes", "Invoiced", "Regular", "Sample", "Delivery Receipt", "Bread", "Quantity"]
      wholesale_show.try(:each) do |delivery|
        csv << [
          delivery.wholesale_customer.name,
          delivery.order.note,
          delivery.order.invoiced                      ? 'T' : 'F',
          delivery.order.regular                       ? 'T' : 'F',
          delivery.order.sample                        ? 'T' : 'F',
          delivery.wholesale_customer.delivery_receipt ? 'T' : 'F',
        ]

        delivery.items.each do |item|
          csv << [nil, nil, nil, nil, nil, nil, item.bread_type.name, item.quantity]
        end
      end

      csv << [nil]
      csv << [nil]
      csv << ["---","---","---","----","----","----"]
      csv << [nil]
      csv << [nil]

      csv << ["Drop-off", "Name", "Bread"]
      show.try(:each) do |delivery|
        delivery.items.each do |item|
          csv << [delivery.collection_point.name, item.subscriber.full_name, item.bread_type.name, @date]
        end
      end
    end
  end

  private

  class WholesaleDelivery
    include Virtus.value_object

    values do
      attribute :wholesale_customer
      attribute :order
      attribute :items, Array
    end
  end

  class WholesaleDeliveryItem
    include Virtus.value_object

    values do
      attribute :bread_type
      attribute :quantity, Integer
    end
  end

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
