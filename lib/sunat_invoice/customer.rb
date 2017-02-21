# frozen_string_literal: true
require_relative 'tributer'

module SunatInvoice
  class Customer < Tributer
    def scheme
      {
        'cbc:InvoiceTypeCode' => :document_type,
        'cbc:ID' => :document_number,
        'cac:AccountingCustomerParty' => {
          'cbc:CustomerAssignedAccountID' => @ruc,
          'cbc:AdditionalAccountID' => @document_type,
          'cac:Party' => {
            'cac:PartyLegalEntity' => {
              'cbc:RegistrationName' => @registration_name
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
