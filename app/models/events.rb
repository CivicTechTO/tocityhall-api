class Event < ActiveRecord::Base
  self.table_name = 'opencivicdata_event'

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-event/#{uuid}"

    self.find(ocd_uuid)
  end
end
