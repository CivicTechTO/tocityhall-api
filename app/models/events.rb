class Event < ActiveRecord::Base
  self.table_name = 'opencivicdata_event'
  default_scope { where jurisdiction_id: TORONTO_COUNCIL_JUR_ID }

  def self.find_by_uuid(uuid)
    ocd_uuid = "ocd-event/#{uuid}"

    self.find(ocd_uuid)
  end
end
