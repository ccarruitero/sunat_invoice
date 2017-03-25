# frozen_string_literal: true
require_relative 'tributer'

module SunatInvoice
  class Customer < Tributer
    def scheme
      {
        'cac:AccountingCustomerParty' => {
          'cbc:CustomerAssignedAccountID' => @ruc,
          'cbc:AdditionalAccountID' => @document_type,
          'cac:Party' => {
            'cac:PartyLegalEntity' => {
              'cbc:RegistrationName' => @registration_name
            }
          }
        },
        'cac:LegalMonetaryTotal' => {
          'cbc:ChargeTotalAmount' => :total_amount
        }
      }
    end
  end
end
