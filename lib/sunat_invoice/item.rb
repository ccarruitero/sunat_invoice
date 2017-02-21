# frozen_string_literal: true
require_relative 'utils'

module SunatInvoice
  class Item
    attr_accessor :quantity, :description, :price, :price_code

    def tag_xml
      scheme
    end

    def scheme
      # UN/ECE rec 20- Unit Of Measure
      # http://www.unece.org/fileadmin/DAM/cefact/recommendations/rec20/rec20_rev3_Annex2e.pdf
      {
        'cbc:InvoicedQuantity' => @quantity,
        'cac:InvoiceLine' => {
          # each child require an InvoiceLine
          'cac:Item' => {
            'cbc:Description' => @description
          },
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
      Gyoku.xml(isc_tax) + Gyoku.xml(igv_tax) + Gyoku.xml(other_tax)
    end

    def concat_main(main_xml)
      concat_xml(main_xml, tag_xml)
    end
  end
end
