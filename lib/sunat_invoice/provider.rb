# frozen_string_literal: true
require_relative 'tributer'
require_relative 'utils'

module SunatInvoice
  class Provider < Tributer
    include Utils

    attr_accessor :signature_id, :signature_location_id, :uri, :pk_file,
                  :cert_file

    def address(xml)
      xml['cbc'].ID @ubigeo
      xml['cbc'].StreetName @street
      xml['cbc'].CitySubdivisionName @zone
      xml['cbc'].CityName @province
      xml['cbc'].CountrySubentity @department
      xml['cbc'].District @district
      build_country(xml)
    end

    def build_country(xml)
      xml['cac'].Country do
        xml['cbc'].IdentificationCode country_code
      end
    end

    def build_name(xml)
      xml['cac'].PartyName do
        xml['cbc'].Name name
      end
    end

    def build_registration_name(xml)
      xml['cac'].PartyLegalEntity do
        xml['cbc'].RegistrationName name
      end
    end

    def info(xml)
      xml['cac'].AccountingSupplierParty do
        xml['cbc'].CustomerAssignedAccountID ruc
        xml['cbc'].AdditionalAccountID document_type
        xml['cac'].Party do
          build_name(xml)
          xml['cac'].PostalAddress { address(xml) }
          build_registration_name(xml)
        end
      end
    end
  end
end
