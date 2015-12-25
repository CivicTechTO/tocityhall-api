class EventRelatedEntity < ActiveRecord::Base
  self.table_name = 'opencivicdata_eventrelatedentity'
  belongs_to :agenda_item
  belongs_to :bill
  belongs_to :organization
  belongs_to :person
end
