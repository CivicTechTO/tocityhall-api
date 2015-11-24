RACK_ENV = (ENV['RACK_ENV'] || 'development').to_sym
require 'bundler'
Bundler.require(:default, RACK_ENV)

require 'active_support/core_ext/hash'

module PrettyJSON
  def self.call(object, env)
    JSON.pretty_generate(JSON.parse(object.to_json))
  end
end

class App < Grape::API
  version 'v1', using: :path
  format :json
  formatter :json, PrettyJSON

  desc "Get a list of councillors"
  get :councillors do
    Person.limit(20).map do |person|
      person.slice :id, :name, :image
    end
  end

  namespace :councillors do
    route_param :id do
      desc "Get a specific councillor"
      get do
        Person.find(params[:id])
      end

      desc "Get a specific councillor's votes"
      get 'votes' do
        Person.find(params[:id]).person_votes.all
      end
    end
  end
end

Grape::ActiveRecord.database_file = 'db/config.yml'
ActiveRecord::Base.table_name_prefix = 'opencivicdata_'

class Person < ActiveRecord::Base
  self.table_name = 'opencivicdata_person'
  has_many :person_votes, foreign_key: :voter_id
end

class PersonVote < ActiveRecord::Base
  self.table_name = 'opencivicdata_personvote'
  belongs_to :person
end
