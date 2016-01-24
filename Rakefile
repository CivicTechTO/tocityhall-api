require 'dotenv'
require 'bundler/setup'
require 'grape/activerecord/rake'

namespace :db do
  task :environment do
    require_relative 'app'
  end
end

namespace :tocityhall do
  desc 'Migrate staging Heroku database into production'
  task :migrate_stage_to_prod do
    staging = 'tocityhall-api-staging'
    production = 'tocityhall-api'
    sh "heroku config --shell --app #{staging} | grep DATABASE_URL > .env"
    Dotenv.load
    sh "heroku pg:reset DATABASE --app #{production}"
    sh "heroku pg:push $DATABASE_URL DATABASE --app #{production}"
  end
end
