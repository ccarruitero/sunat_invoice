# frozen_string_literal: true
require_relative 'tributer'
require_relative 'utils'

module SunatInvoice
  class Provider < Tributer
    include Utils

    attr_accessor :signature_id, :uri, :pk_file, :cert_file

    def address(xml)
      xml['cbc'].ID @ubigeo
      xml['cbc'].StreetName @street
      xml['cbc'].CitySubdivisionName @zone
      xml['cbc'].CityName @province
      xml['cbc'].CountrySubentity @departament
      xml['cbc'].District @district
      xml['cac'].Country do
        xml['cbc'].IdentificationCode @country_code
      end
    end

    def info(xml)
      xml['cac'].AccountingSupplierParty do
        xml['cbc'].CustomerAssignedAccountID @ruc
        xml['cbc'].AdditionalAccountID @document_type
        xml['cac'].Party do
          xml['cac'].PartyName do
            xml['cbc'].Name @name
          end
          xml['cac'].PostalAddress { address(xml) }
          xml['cac'].PartyLegalEntity do
            xml['cbc'].RegistrationName @name
          end
        end
      end
    end
  end
end
