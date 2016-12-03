class Api::BaseController < JSONAPI::ResourceController
  before_action :doorkeeper_authorize! # Require access token for all actions
end
