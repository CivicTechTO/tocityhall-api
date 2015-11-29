class LegislativeSession < ActiveRecord::Base
  self.table_name = 'opencivicdata_legislativesession'
  has_many :bills
  has_many :people, -> { distinct }, through: :bills
end
