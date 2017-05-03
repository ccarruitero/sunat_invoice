# frozen_string_literal: true
require_relative 'helper'
include SunatInvoice

setup do
  @item = SunatInvoice::Item.new
  @item.quantity = 200
  @item.description = 'item description'
  @item.price = 69
  @item.price_code = '01'
  @parsed_xml = Nokogiri::XML(@item.xml, &:noblanks)
end

def invoice_setup
  # add item to invoice in order to setup namespaces
  invoice = SunatInvoice::Invoice.new
  invoice_xml = Nokogiri::XML(invoice.xml, &:noblanks)
  invoice_xml.at('Invoice').add_child(@item.xml)
  @item_xml = invoice_xml.xpath('//cac:InvoiceLine')
end

test 'not broken' do
  assert !@item.nil?
end

# xml
test 'xml start with cac:InvoiceLine tag' do
  assert @parsed_xml.root.name == 'cac:InvoiceLine'
end

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
  assert_equal @item.price.to_s, price.first.content
  # /Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount/@currencyID

  ref_pricing = @item_xml.xpath('//cac:PricingReference')
  alt_condition_price = ref_pricing.xpath('//cac:AlternativeConditionPrice')
  assert_equal 1, alt_condition_price.count

  alt_price = alt_condition_price.xpath('//cbc:PriceAmount')
  assert_equal @item.price.to_s, alt_price.first.content
  # //cac:AlternativeConditionPrice/cbc:PriceAmount/@currencyID

  price_type = alt_condition_price.xpath('//cbc:PriceTypeCode')
  assert_equal @item.price_code, price_type.first.content
end

test 'has taxs' do
  invoice_setup
  taxs = @item_xml.xpath('//cac:TaxTotal')
  assert_equal 2, taxs.count
end