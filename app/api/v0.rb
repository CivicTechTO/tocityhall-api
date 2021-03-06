require_relative 'v0/api'
require 'grape-swagger'

class ApiV0 < Grape::API

  swagger_path = 'swagger'

  get do
    # Redirect base url to Swagger docs
    redirect "http://petstore.swagger.io/?url=#{request.scheme}://#{request.host_with_port}/#{version}/#{swagger_path}"
  end

  content_type :json, 'application/json'
  default_format :json
  formatter :json, PrettyJSON

  helpers V0Helpers

  include Grape::Kaminari
  paginate per_page: 20, max_per_page: 30, offset: false

  # No need to implement while we're just working on Toronto.
  # namespace :divisions
  # namespace :jurisdictions

  mount App::API::LegislativeSessions
  mount App::API::Organizations
  mount App::API::Posts
  mount App::API::Events
  mount App::API::AgendaItems
  mount App::API::Memberships
  mount App::API::People
  mount App::API::Bills
  mount App::API::Votes
  mount App::API::Locations

  add_swagger_documentation \
    mount_path: swagger_path,
    hide_documentation_path: true,
    hide_format: true,
    api_version: 'v0',
    base_path: 'v0'

end
