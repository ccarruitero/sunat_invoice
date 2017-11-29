# frozen_string_literal: true
require_relative 'helper'
include SunatInvoice

setup do
  @item = SunatInvoice::Item.new( quantity: 200,
                                  description: 'item description',
                                  price: 69, price_code: '01')
  @item.taxes << SunatInvoice::Tax.new(amount: 12.42, tax_type: :igv)
end

def invoice_setup
  # add item to invoice in order to setup namespaces
  invoice = SunatInvoice::Invoice.new
  invoice.items << @item
  invoice_xml = Nokogiri::XML(invoice.xml, &:noblanks)
  @item_xml = invoice_xml.xpath('//cac:InvoiceLine')
end

test 'not broken' do
  assert !@item.nil?
end

# xml
test 'has unit code and quantity' do
  invoice_setup
  quantity = @item_xml.xpath('//cbc:InvoicedQuantity')
  assert quantity.count.positive?
  assert_equal @item.quantity.to_s, quantity.first.content
  # /Invoice/cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode
end

test 'has a description' do
  invoice_setup
  description = @item_xml.xpath('//cbc:Description')
  assert_equal @item.description, description.first.content
end

test 'has unit price' do
  invoice_setup
  price = @item_xml.xpath('//cac:Price/cbc:PriceAmount')
  assert_equal @item.bi_value.to_s, price.first.content
  # /Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount/@currencyID

  ref_pricing = @item_xml.xpath('//cac:PricingReference')
  alt_condition_price = ref_pricing.xpath('//cac:AlternativeConditionPrice')
  assert_equal 1, alt_condition_price.count

  alt_price = ref_pricing.xpath('//cac:AlternativeConditionPrice/cbc:PriceAmount')
  assert_equal @item.price.to_s, alt_price.first.content
  # //cac:AlternativeConditionPrice/cbc:PriceAmount/@currencyID

  price_type = alt_condition_price.xpath('//cbc:PriceTypeCode')
  assert_equal @item.price_code, price_type.first.content
end

test 'has taxes' do
  invoice_setup
  taxes = @item_xml.xpath('//cac:TaxTotal')
  assert_equal 1, taxes.count
end
