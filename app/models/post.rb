class Post < ActiveRecord::Base
  self.table_name = 'opencivicdata_post'
  has_many :memberships
  has_many :people, through: :memberships

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-post/#{uuid}"

    self.find(ocd_uuid)
  end

  def self.in_toronto
    self.where(organization_id: TORONTO_COUNCIL_ORG_ID)
  end
end
