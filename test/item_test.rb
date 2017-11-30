# frozen_string_literal: true
require_relative 'helper'
include SunatInvoice

setup do
  @item = SunatInvoice::Item.new(quantity: 200, price: 69, price_code: '01',
                                 description: 'item description')
  @item.taxes << SunatInvoice::Tax.new(amount: 12.42, tax_type: :igv)
  invoice_setup
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
  quantity = @item_xml.xpath('//cbc:InvoicedQuantity')
  assert quantity.count.positive?
  assert_equal @item.quantity.to_s, quantity.first.content
  # /Invoice/cac:InvoiceLine/cbc:InvoicedQuantity/@unitCode
end

test 'has a description' do
  description = @item_xml.xpath('//cbc:Description')
  assert_equal @item.description, description.first.content
end

test 'has unit prices' do
  price = @item_xml.xpath('//cac:Price/cbc:PriceAmount')
  assert_equal @item.price.to_s, price.first.content
  # /Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount/@currencyID

  ref_pricing = @item_xml.xpath('//cac:PricingReference')
  alt_condition_price = ref_pricing.xpath('//cac:AlternativeConditionPrice')
  assert_equal 1, alt_condition_price.count

  tag = '//cac:AlternativeConditionPrice/cbc:PriceAmount'
  alt_price = ref_pricing.xpath(tag)
  assert_equal @item.sale_price.to_s, alt_price.first.content
  # //cac:AlternativeConditionPrice/cbc:PriceAmount/@currencyID

  price_type = alt_condition_price.xpath('//cbc:PriceTypeCode')
  assert_equal @item.price_code, price_type.first.content
end

# taxes
test 'has taxes' do
  taxes = @item_xml.xpath('//cac:InvoiceLine/cac:TaxTotal')
  assert_equal 1, taxes.count
end

test 'has amount in correct tag' do
  tag_path = '//cac:InvoiceLine/cac:TaxTotal/cbc:TaxAmount'
  amount = @item_xml.xpath(tag_path)
  assert_equal amount.count, 1
  assert_equal amount.first.content, '12.42'
  # cac:TaxTotal/cbc:TaxAmount/@currencyID
end

test 'has correct values in TaxScheme' do
  tag_path = '//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme'
  id = @item_xml.xpath("#{tag_path}/cbc:ID")
  assert_equal id.first.content, '1000'

  name = @item_xml.xpath("#{tag_path}/cbc:Name")
  assert_equal name.first.content, 'IGV'

  tax_code = @item_xml.xpath("#{tag_path}/cbc:TaxTypeCode")
  assert_equal tax_code.first.content, 'VAT'
end
