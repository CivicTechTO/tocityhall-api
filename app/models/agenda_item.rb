class AgendaItem < ActiveRecord::Base
  self.table_name = 'opencivicdata_eventagendaitem'
  belongs_to :event
  has_many :event_related_entities

  def self.all_by_event_time()
    self.all.joins(:event).order('opencivicdata_event.start_time').order('opencivicdata_eventagendaitem.order::int')
  end
end
