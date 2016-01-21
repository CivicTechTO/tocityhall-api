class AgendaItem < ActiveRecord::Base
  self.table_name = 'opencivicdata_eventagendaitem'
  default_scope { joins(:event).order('opencivicdata_event.start_time').order('opencivicdata_eventagendaitem.order::int') }
  belongs_to :event
  has_many :event_related_entities

  def self.upcoming
    self.all.where('opencivicdata_event.start_time > ?', Time.now)
  end
end
