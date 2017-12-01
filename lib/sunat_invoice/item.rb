# frozen_string_literal: true
require_relative 'utils'

module SunatInvoice
  class Item < Model
    include Utils

    attr_accessor :quantity, :description, :price, :price_code, :unit_code,
                  :taxes

    def initialize(*args)
      # * quantity - quantity of item
      # * description - name or description of product or service
      # * price - unit price without taxes
      # * price_code - type unit price (Catalogs::CATALOG_16)
      # * unit_code - unit of measure
      #   UN/ECE rec 20- Unit Of Measure
      #   http://www.unece.org/fileadmin/DAM/cefact/recommendations/rec20/rec20_rev3_Annex2e.pdf
      # * taxes - An array of SunatInvoice::Tax
      super(*args)
      @taxes ||= []
    end

    def bi_value
      # bi of sale = price without taxes * quantity
      (@price.to_f * @quantity.to_f).round(2)
    end

    def sale_taxes
      # generate and object with taxes sum by type
      sums = {}
      taxes.each do |tax|
        sums[tax.tax_type] ||= 0
        sums[tax.tax_type] = (tax.amount.to_f * quantity.to_f).round(2)
      end
      sums
    end

    def sale_price
      # unit price with tax
      (@price.to_f + sum_taxes).round(2)
    end

    def sum_taxes
      taxes.map(&:amount).sum
    end

    def xml(xml, index, currency)
      xml['cac'].InvoiceLine do
        build_item(xml)
        xml['cbc'].InvoicedQuantity(@quantity, unitCode: unit_code)
        xml['cac'].Price do
          amount_xml(xml['cbc'], 'PriceAmount', price, currency)
        end
        xml['cac'].PricingReference do
          xml['cac'].AlternativeConditionPrice do
            amount_xml(xml['cbc'], 'PriceAmount', sale_price, currency)
            xml['cbc'].PriceTypeCode price_code
          end
        end
        amount_xml(xml['cbc'], 'LineExtensionAmount', bi_value, currency)
        xml['cbc'].ID(index + 1)
        taxes_xml(xml, currency)
      end
    end

    def build_item(xml)
      xml['cac'].Item do
        xml['cbc'].Description description
      end
    end

    def taxes_xml(xml, currency)
      taxes&.each do |tax|
        tax.xml(xml, currency)
      end
    end
  end
end
