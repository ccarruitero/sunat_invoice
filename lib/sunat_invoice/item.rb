# frozen_string_literal: true
require_relative 'utils'

module SunatInvoice
  class Item
    include Utils

    attr_accessor :quantity, :description, :price, :price_code, :unit_code,
                  :igv, :isc, :other

    def bi_value
      sale_value / 1.18
    end

    def sale_value
      @price.to_f * @quantity.to_f
    end

    def xml(xml, index)
      # UN/ECE rec 20- Unit Of Measure
      # http://www.unece.org/fileadmin/DAM/cefact/recommendations/rec20/rec20_rev3_Annex2e.pdf
      xml['cac'].InvoiceLine do
        xml['cac'].Item do
          xml['cbc'].Description @description
        end
        xml['cbc'].InvoicedQuantity @quantity
        # TODO: add attributes
        xml['cac'].Price do
          xml['cbc'].PriceAmount bi_value # valor unitario
        end
        xml['cac'].PricingReference do
          xml['cac'].AlternativeConditionPrice do
            xml['cbc'].PriceAmount @price # precio venta
            xml['cbc'].PriceTypeCode @price_code
          end
        end
        xml['cbc'].LineExtensionAmount sale_value
        xml['cbc'].ID(index + 1)
        # taxs
      end
    end

    def taxs_xml
      igv_tax(@igv_amount) + isc_tax(@isc_amount)
    end
  end
end
