require_relative 'tributer'

module SunatInvoice
  class Customer < Tributer
    def scheme
      {
        'cbc:InvoiceTypeCode' => :document_type,
        'cbc:ID' => :document_number,
        'cac:AccountingCustomerParty' => {
          'cbc:CustomerAssignedAccountID' => @customer.ruc,
          'cbc:AdditionalAccountID' => @customer.document_type,
          'cac:Party' => {
            'cac:PartyLegalEntity' => {
              'cbc:RegistrationName' => @customer.registration_name
            }
          }
        },
        'cac:InvoiceLine' => {},
        'cac:LegalMonetaryTotal' => {
          'cbc:ChargeTotalAmount' => :total_amount
        }
      }
    end
  end
end
