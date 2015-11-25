class Bill < ActiveRecord::Base
  self.table_name = 'opencivicdata_bill'
  has_many :vote_events
  has_many :people, through: :vote_events
  has_many :person_votes, through: :vote_events
  belongs_to :legislative_session
end
