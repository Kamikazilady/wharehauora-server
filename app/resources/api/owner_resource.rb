class Api::OwnerResource < JSONAPI::Resource
  immutable
  model_name 'User'
end
