class Event < ActiveRecord::Base
  self.table_name = 'opencivicdata_event'
  belongs_to :location
  has_many :agenda_items
  has_many :event_participants
  has_many :organizations, through: :event_participants
  default_scope { order :start_time }

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-event/#{uuid}"

    self.find(ocd_uuid)
  end
end
