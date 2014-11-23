json.array!(@collection_points) do |collection_point|
  json.extract! collection_point, :id, :address, :post_code, :notes, :name
  json.url collection_point_url(collection_point, format: :json)
end
