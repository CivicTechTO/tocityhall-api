class AgendaItem < ActiveRecord::Base
  self.table_name = 'opencivicdata_eventagendaitem'
  default_scope { includes(:event)
    .order('opencivicdata_event.start_time')
    .order('opencivicdata_event.name')
    .order('opencivicdata_eventagendaitem.order::int')
  }
  belongs_to :event
  has_many :event_related_entities

  def bill
    self.event_related_entities[0]
  end

  def self.votable
    self.where.contains(classification: ['action'])
  end

  def self.upcoming
    self.where('opencivicdata_event.start_time > ?', Time.now)
  end

  def self.latest
    # Approximates latest by assuming furthest ahead are latest :/
    self.reorder('opencivicdata_event.start_time DESC').order('opencivicdata_eventagendaitem.order::int')
  end
end
