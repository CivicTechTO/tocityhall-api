RACK_ENV = (ENV['RACK_ENV'] || 'development').to_sym
require 'bundler'
Bundler.require(:default, RACK_ENV)

require 'active_support/core_ext/hash'

TORONTO_COUNCIL_ORG_ID = 'ocd-organization/d151a57c-2600-4c3a-808a-863436e338ff'
TORONTO_COUNCIL_JUR_ID = 'ocd-jurisdiction/country:ca/csd:3520005/legislature'

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
      get do
        Person.find(params[:id])
      end

      get :person_votes do
        Person.find(params[:id]).person_votes.limit(20)
      end

      get :vote_events do
        Person.find(params[:id]).vote_events.limit(20)
      end
    end
  end

  desc "Get a list of bills"
  get :bills do
    Bill.where(from_organization_id: TORONTO_COUNCIL_ORG_ID).limit(20).map do |bill|
      {
        id: bill.id,
        identifier: bill.identifier,
        title: bill.title,
        legislative_session: bill.legislative_session.name,
        vote_events: bill.vote_events.all.map do |event|
          event.slice :start_date, :result, :motion_text, :motion_classification
        end
      }
    end
  end

  namespace :bills do
    route_param :id do
      get do
        Bill.find(params[:id])
      end

      get 'vote_events' do
        Bill.find(params[:id]).vote_events.limit(20)
      end
    end
  end

  get :sessions do
    LegislativeSession.where(jurisdiction_id: TORONTO_COUNCIL_JUR_ID).limit(20)
  end

  namespace :sessions do
    route_param :id do
      get do
        LegislativeSession.find(params[:id])
      end

      get :bills do
        LegislativeSession.find(params[:id]).bills.limit(20)
      end
    end
  end
end

Grape::ActiveRecord.database_file = 'db/config.yml'
ActiveRecord::Base.table_name_prefix = 'opencivicdata_'

class Person < ActiveRecord::Base
  self.table_name = 'opencivicdata_person'
  has_many :person_votes, foreign_key: :voter_id
  has_many :vote_events, through: :person_votes
end

class PersonVote < ActiveRecord::Base
  self.table_name = 'opencivicdata_personvote'
  belongs_to :person
  belongs_to :vote_event
end

class Bill < ActiveRecord::Base
  self.table_name = 'opencivicdata_bill'
  belongs_to :legislative_session
  has_many :vote_events
end

class VoteEvent < ActiveRecord::Base
  self.table_name = 'opencivicdata_voteevent'
  belongs_to :bill
  belongs_to :legislative_session
  has_many :person_votes
end

class LegislativeSession < ActiveRecord::Base
  self.table_name = 'opencivicdata_legislativesession'
  has_many :bills
end
