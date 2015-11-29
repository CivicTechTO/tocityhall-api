class VoteEvent < ActiveRecord::Base
  self.table_name = 'opencivicdata_voteevent'
  has_many :person_votes
  has_many :people, through: :person_votes
  has_many :vote_counts
  belongs_to :bill
  belongs_to :legislative_session

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-vote/#{uuid}"

    self.find(ocd_uuid)
  end

end
