json.array!(@bread_types) do |bread_type|
  json.extract! bread_type, :id, :name, :sour_dough, :notes
  json.url bread_type_url(bread_type, format: :json)
end
