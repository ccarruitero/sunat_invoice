# frozen_string_literal: true

require_relative 'line'

module SunatInvoice
  class Item < Line
    attr_accessor :quantity, :description, :price, :price_code, :unit_code,
                  :price_included_tax

    def initialize(*args)
      # * quantity - quantity of item
      # * description - name or description of product or service
      # * price - unit price without taxes
      # * price_code - type unit price (Catalogs::CATALOG_16)
      # * unit_code - unit of measure
      #   UN/ECE rec 20- Unit Of Measure
      #   http://www.unece.org/fileadmin/DAM/cefact/recommendations/rec20/rec20_rev3_Annex2e.pdf
      # * taxes - An array of SunatInvoice::Tax
      # * price_included_tax - price with taxes
      super(*args)
      @taxes ||= []
    end

    def line_tag_name
      'InvoiceLine'
    end

    def quantity_tag_name
      'InvoicedQuantity'
    end

    def xml(xml, index, currency)
      xml['cac'].send(line_tag_name) do
        build_basic_line_xml(xml, index)
        amount_xml(xml['cbc'], 'LineExtensionAmount', bi_value, currency)
        build_pricing_reference(xml, currency)
        build_taxes_xml(xml, currency)
        build_item(xml)
        build_price(xml, currency)
      end
    end

    def set_price
      @price ||= (@price_included_tax - sum_taxes).round(2) if @price_included_tax
    end

    def bi_value
      # bi of sale = price without taxes * quantity
      set_price
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
      @price_included_tax || (@price.to_f + sum_taxes).round(2)
    end

    private

    def sum_taxes
      taxes.map(&:amount).sum
    end

    def build_basic_line_xml(xml, index)
      xml['cbc'].ID(index + 1)
      xml['cbc'].send(quantity_tag_name, quantity, unitCode: unit_code)
    end

    def build_item(xml)
      xml['cac'].Item do
        xml['cbc'].Description description
      end
    end

    def build_pricing_reference(xml, currency)
      xml['cac'].PricingReference do
        xml['cac'].AlternativeConditionPrice do
          amount_xml(xml['cbc'], 'PriceAmount', sale_price, currency)
          xml['cbc'].PriceTypeCode price_code
        end
      end
    end

    def build_price(xml, currency)
      xml['cac'].Price do
        amount_xml(xml['cbc'], 'PriceAmount', price, currency)
      end
    end
  end
end
