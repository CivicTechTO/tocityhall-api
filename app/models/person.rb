class Person < ActiveRecord::Base
  self.table_name = 'opencivicdata_person'
  has_many :person_votes, foreign_key: :voter_id
  has_many :vote_events, through: :person_votes
end
