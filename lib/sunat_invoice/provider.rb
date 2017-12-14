# frozen_string_literal: true

require_relative 'tributer'
require_relative 'utils'

module SunatInvoice
  class Provider < Tributer
    include Utils

    attr_accessor :signature_id, :signature_location_id, :pk_file, :cert_file

    def info(xml, with_address = true)
      xml['cac'].AccountingSupplierParty do
        xml['cbc'].CustomerAssignedAccountID ruc
        xml['cbc'].AdditionalAccountID document_type
        build_party_xml(xml, with_address)
      end
    end

    private

    def build_party_xml(xml, with_address)
      xml['cac'].Party do
        build_name(xml) if commercial_name
        xml['cac'].PostalAddress { address(xml) } if with_address
        build_registration_name(xml)
      end
    end

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
        xml['cbc'].Name commercial_name
      end
    end

    def build_registration_name(xml)
      xml['cac'].PartyLegalEntity do
        xml['cbc'].RegistrationName name
      end
    end
  end
end
