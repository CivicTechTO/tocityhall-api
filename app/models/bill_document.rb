class BillDocument < ActiveRecord::Base
  self.table_name = 'opencivicdata_billdocument'
  belongs_to :bill
  has_many :bill_document_links, foreign_key: :document_id
end
