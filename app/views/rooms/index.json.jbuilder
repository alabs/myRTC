json.array!(@rooms) do |room|
  json.extract! room, :name, :subscribers, :password
  json.url room_url(room, format: :json)
end
