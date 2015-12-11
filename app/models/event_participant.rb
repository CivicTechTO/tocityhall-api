class EventParticipant < ActiveRecord::Base
  self.table_name = 'opencivicdata_eventparticipant'
  belongs_to :organization
  belongs_to :event
  belongs_to :person
end
