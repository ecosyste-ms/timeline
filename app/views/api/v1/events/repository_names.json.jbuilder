json.names @names
json.newest do
  json.extract! @newest, :id, :repository, :created_at
end
json.oldest do
  json.extract! @oldest, :id, :repository, :created_at
end