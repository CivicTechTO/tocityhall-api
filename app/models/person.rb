class Person < ActiveRecord::Base
  self.table_name = 'opencivicdata_person'
  has_many :person_votes, foreign_key: :voter_id
  has_many :vote_events, through: :person_votes
  has_many :memberships
  has_many :posts, through: :memberships

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-person/#{uuid}"

    self.find(ocd_uuid)
  end

end
