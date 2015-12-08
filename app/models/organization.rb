class Organization < ActiveRecord::Base
  self.table_name = 'opencivicdata_organization'
  has_many :posts
  has_many :memberships
  has_many :people, through: :memberships
  has_many :children, class_name: 'Organization', foreign_key: 'parent_id'

  belongs_to :parent, class_name: 'Organization'
  belongs_to :membership

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-organization/#{uuid}"

    self.find(ocd_uuid)
  end

end

