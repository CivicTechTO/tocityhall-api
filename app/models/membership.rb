class Membership < ActiveRecord::Base
  self.table_name = 'opencivicdata_membership'
  belongs_to :person
  belongs_to :post
  belongs_to :organization

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-membership/#{uuid}"

    self.find(ocd_uuid)
  end
end
