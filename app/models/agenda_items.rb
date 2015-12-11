class AgendaItem < ActiveRecord::Base
  self.table_name = 'opencivicdata_eventagendaitem'
  default_scope { order('opencivicdata_eventagendaitem.order::int') }
  belongs_to :event
end
