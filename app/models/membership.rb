class Membership < ActiveRecord::Base
  self.table_name = 'opencivicdata_membership'
  belongs_to :person
  belongs_to :post

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-membership/#{uuid}"

    self.find(ocd_uuid)
  end

  def self.in_toronto
    self.where(organization_id: TORONTO_COUNCIL_ORG_ID)
  end
end
