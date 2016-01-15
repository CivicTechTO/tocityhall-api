class Post < ActiveRecord::Base
  self.table_name = 'opencivicdata_post'
  has_many :memberships
  has_many :people, through: :memberships
  belongs_to :division
  belongs_to :organization

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-post/#{uuid}"

    self.find(ocd_uuid)
  end
end
