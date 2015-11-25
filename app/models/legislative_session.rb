class LegislativeSession < ActiveRecord::Base
  self.table_name = 'opencivicdata_legislativesession'
  has_many :bills

  def self.in_toronto
    self.where(jurisdiction_id: TORONTO_COUNCIL_JUR_ID)
  end
end
