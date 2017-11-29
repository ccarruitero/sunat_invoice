# frozen_string_literal: true
module SunatInvoice
  class Tax < Model
    TAXES = {
      igv: { id: '1000', name: 'IGV', tax_type_code: 'VAT' },
      isc: { id: '2000', name: 'ISC', tax_type_code: 'EXC' },
      other: { id: '9999', name: 'OTROS', tax_type_code: 'OTH' }
    }.freeze

    attr_accessor :amount, :tax_type, :tax_exemption_reason, :tier_range

    def xml(xml)
      xml['cac'].TaxTotal do
        xml['cbc'].TaxAmount amount
        xml['cac'].TaxSubtotal do
          xml['cbc'].TaxAmount amount
          tax_category(xml)
        end
      end
    end

    def tax_category(xml)
      xml['cac'].TaxCategory do
        xml['cbc'].TaxExemptionReasonCode(tax_exemption_reason) if tax_exemption_reason
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
  end
end