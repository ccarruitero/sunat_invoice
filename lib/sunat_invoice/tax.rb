# frozen_string_literal: true

require_relative 'catalogs'
require_relative 'utils'

module SunatInvoice
  class Tax < Model
    include Utils

    TAXES = {
      igv: { id: '1000', name: 'IGV', tax_type_code: 'VAT' },
      isc: { id: '2000', name: 'ISC', tax_type_code: 'EXC' },
      other: { id: '9999', name: 'OTROS', tax_type_code: 'OTH' }
    }.freeze

    attr_accessor :amount, :tax_type, :tax_exemption_reason, :tier_range

    def initialize(*args)
      super(*args)
      defaults_for_type(tax_type)
    end

    def defaults_for_type(type)
      case type
      when :igv
        @tax_exemption_reason ||= Catalogs::CATALOG_07.first
      when :isc
        @tier_range ||= Catalogs::CATALOG_08.first
      end
    end

    def xml(xml, currency)
      xml['cac'].TaxTotal do
        amount_xml(xml['cbc'], 'TaxAmount', amount, currency)
        xml['cac'].TaxSubtotal do
          amount_xml(xml['cbc'], 'TaxAmount', amount, currency)
          tax_category(xml)
        end
      end
    end

    def tax_category(xml)
      xml['cac'].TaxCategory do
        tax_exemption(xml)
        xml['cbc'].TierRange(tier_range) if tier_range
        tax_scheme(xml)
      end
    end

    def tax_scheme(xml)
      xml['cac'].TaxScheme do
        xml['cbc'].ID tax_data(:id)
        xml['cbc'].Name tax_data(:name)
        xml['cbc'].TaxTypeCode tax_data(:tax_type_code)
      end
    end

    def tax_data(attribute)
      TAXES[tax_type][attribute]
    end

    def tax_exemption(xml)
      return unless tax_exemption_reason
      xml['cbc'].TaxExemptionReasonCode(tax_exemption_reason)
    end
  end
end
