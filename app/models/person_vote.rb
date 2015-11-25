class PersonVote < ActiveRecord::Base
  self.table_name = 'opencivicdata_personvote'
  belongs_to :person, foreign_key: :voter_id
  belongs_to :vote_event
end
