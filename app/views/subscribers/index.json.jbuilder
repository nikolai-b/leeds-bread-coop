json.array!(@subscribers) do |subscriber|
  json.extract! subscriber, :id, :name, :address, :phone, :collection_point_id, :start_date, :paid_until, :bread_type_id, :quantity
  json.url subscriber_url(subscriber, format: :json)
end
