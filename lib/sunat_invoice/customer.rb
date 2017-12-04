# frozen_string_literal: true

require_relative 'tributer'

module SunatInvoice
  class Customer < Tributer
    def info(xml)
      xml['cac'].AccountingCustomerParty do
        xml['cbc'].CustomerAssignedAccountID @ruc
        xml['cbc'].AdditionalAccountID @document_type
        xml['cac'].Party do
          xml['cac'].PartyLegalEntity do
            xml['cbc'].RegistrationName @name
          end
        end
      end
    end
  end
end
