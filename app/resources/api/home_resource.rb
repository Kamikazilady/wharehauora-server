# frozen_string_literal: true
class Api::HomeResource < JSONAPI::Resource
  immutable
  attributes :name
  has_one :owner
end
