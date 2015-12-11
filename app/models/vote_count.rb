class VoteCount < ActiveRecord::Base
  self.table_name = 'opencivicdata_votecount'
  belongs_to :vote_event
end

