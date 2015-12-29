class BillDocumentLink < ActiveRecord::Base
  self.table_name = 'opencivicdata_billdocumentlink'
  belongs_to :bill_document
end

