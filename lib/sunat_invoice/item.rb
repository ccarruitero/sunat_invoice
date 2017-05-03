# frozen_string_literal: true
require_relative 'utils'

module SunatInvoice
  class Item
    include Utils

    attr_accessor :quantity, :description, :price, :price_code, :igv_amount,
                  :isc_amount

    def xml
      main_xml = Gyoku.xml(scheme)
      concat_xml(main_xml, taxs_xml, 'cac:InvoiceLine', 'inside')
    end

    def scheme
      # UN/ECE rec 20- Unit Of Measure
      # http://www.unece.org/fileadmin/DAM/cefact/recommendations/rec20/rec20_rev3_Annex2e.pdf
      {
        'cac:InvoiceLine' => {
          'cac:Item' => {
            'cbc:Description' => @description
          },
          'cbc:InvoicedQuantity' => @quantity,
          'cac:Price' => {
            'cbc:PriceAmount' => @price # valor unitario
          },
          'cac:PricingReference' => {
            'cac:AlternativeConditionPrice' => {
              'cbc:PriceAmount' => @price, # precio venta
              'cbc:PriceTypeCode' => @price_code
            }
          },
          'cbc:LineExtensionAmount' => @valor_venta
          # taxs
        }
      }
    end

    def taxs_xml
      igv_tax(@igv_amount) + isc_tax(@isc_amount)
    end
  end
end
