class VoteEvent < ActiveRecord::Base
  self.table_name = 'opencivicdata_voteevent'
  has_many :person_votes
  has_many :people, through: :person_votes
  belongs_to :bill
  belongs_to :legislative_session
end
