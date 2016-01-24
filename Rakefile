require 'dotenv/tasks'
require 'bundler/setup'
require 'grape/activerecord/rake'

namespace :db do
  task :environment do
    require_relative 'app'
  end
end

namespace :tocityhall do
  staging = 'tocityhall-api-staging'
  production = 'tocityhall-api'

  task :write_dotenv do
    sh "heroku config --shell --app #{staging} | grep DATABASE_URL > .env"
  end

  desc 'Migrate staging Heroku database into production'
  task :migrate_stage_to_prod => [:write_dotenv, :dotenv] do
    sh "heroku pg:reset DATABASE --app #{production}"
    sh "heroku pg:push $DATABASE_URL DATABASE --app #{production}"
  end
end
