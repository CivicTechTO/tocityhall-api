require './config/environment'
require './main'
require 'rack/cors'

# Let grape-swagger work from petstore demo
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [ :get, :post, :put, :delete, :options ]
  end
end

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run ApiApp
