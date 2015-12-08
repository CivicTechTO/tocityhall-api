require_relative 'v0/api'
require 'grape-swagger'

class ApiV0 < Grape::API
  format :json
  helpers V0Helpers
  formatter :json, PrettyJSON

  include Grape::Kaminari
  paginate per_page: 20, max_per_page: 30, offset: false

  # No need to implement while we're just working on Toronto.
  # namespace :divisions
  # namespace :jurisdictions

  mount App::API::LegislativeSessions
  mount App::API::Organizations
  mount App::API::Posts
  mount App::API::Events
  mount App::API::Memberships
  mount App::API::People
  mount App::API::Bills
  mount App::API::Votes

  add_swagger_documentation mount_path: 'docs',
    base_path: '/v0'

end
