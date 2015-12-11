class Location < ActiveRecord::Base
  self.table_name = 'opencivicdata_eventlocation'
  #has_many :events
end
