class Bill < ActiveRecord::Base
  self.table_name = 'opencivicdata_bill'
  has_many :vote_events
  has_many :people, through: :vote_events
  has_many :person_votes, through: :vote_events
  belongs_to :legislative_session

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-bill/#{uuid}"

    self.find(ocd_uuid)
  end

  def self.in_toronto
    self.where(from_organization_id: TORONTO_COUNCIL_ORG_ID)
  end
end
