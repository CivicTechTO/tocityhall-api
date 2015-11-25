class LegislativeSession < ActiveRecord::Base
  self.table_name = 'opencivicdata_legislativesession'
  has_many :bills
end
