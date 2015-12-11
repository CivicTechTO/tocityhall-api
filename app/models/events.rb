class Event < ActiveRecord::Base
  self.table_name = 'opencivicdata_event'
  belongs_to :location
  #belongs_to :jurisdiction

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-event/#{uuid}"

    self.find(ocd_uuid)
  end
end
