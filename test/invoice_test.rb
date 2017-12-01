# frozen_string_literal: false
require_relative 'helper'
include SunatInvoice

setup do
  @provider = FactoryBot.build(:provider)
  @invoice = FactoryBot.build(:invoice, provider: @provider)
  tax = SunatInvoice::Tax.new(amount: 3.6, tax_type: :igv)
  item_attr = { quantity: 10, price: 20, price_code: '01', taxes: [tax] }
  @invoice.items << SunatInvoice::Item.new(item_attr)
  @parsed_xml = Nokogiri::XML(@invoice.xml, &:noblanks)
end

test 'is not broken' do
  assert !@invoice.nil?
end

test 'has namespaces' do
  cbc = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
  namespaces = @parsed_xml.css('Invoice').first.namespaces
  assert_equal namespaces['xmlns:cbc'], cbc
end

test 'xml start with invoice tag' do
  assert_equal @parsed_xml.root.name, 'Invoice'
end

test 'has a date' do
  date = @parsed_xml.xpath('//cbc:IssueDate')
  assert_equal date.first.content, DateTime.now.strftime('%Y-%m-%d')
end

test 'has a signature' do
  # /ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature
  signature = @parsed_xml.xpath('//ext:UBLExtensions/ext:UBLExtension')
  assert_equal signature.xpath('//ext:ExtensionContent/ds:Signature').count, 1

  # /cac:Signature
  signature = @parsed_xml.xpath('//cac:Signature')
  assert_equal signature.count, 1
end

test 'has a registration name' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty/cac:Party')
  name = provider.xpath('//cac:PartyLegalEntity/cbc:RegistrationName')
  assert_equal name.first.content, @provider.name
end

test 'has a name' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty/cac:Party')
  name = provider.xpath('//cac:PartyName/cbc:Name')
  assert_equal name.first.content, @provider.name
end

test 'has an address' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty/cac:Party')
  ubigeo = provider.xpath('//cac:PostalAddress/cbc:ID')
  assert_equal ubigeo.first.content, @provider.ubigeo

  street = provider.xpath('//cac:PostalAddress/cbc:StreetName')
  assert_equal street.first.content, @provider.street

  urbanizacion = provider.xpath('//cac:PostalAddress/cbc:CitySubdivisionName')
  assert_equal urbanizacion.first.content, @provider.zone

  provincia = provider.xpath('//cac:PostalAddress/cbc:CityName')
  assert_equal provincia.first.content, @provider.province

  # Departamento
  departamento = provider.xpath('//cac:PostalAddress/cbc:CountrySubentity')
  assert_equal departamento.first.content, @provider.department

  # Distrito
  distrito = provider.xpath('//cac:PostalAddress/cbc:District')
  assert_equal distrito.first.content, @provider.district

  country_code_path = '//cac:PostalAddress/cac:Country/cbc:IdentificationCode'
  country_code = provider.xpath(country_code_path)
  assert_equal country_code.first.content, @provider.country_code.to_s
end

test 'has a ruc' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty')
  ruc = provider.xpath('//cbc:CustomerAssignedAccountID')
  assert_equal ruc.first.content, @provider.ruc

  document_type = provider.xpath('//cbc:AdditionalAccountID')
  assert_equal document_type.first.content, @provider.document_type.to_s
end

test 'has an invoice type' do
  invoice_type = @parsed_xml.xpath('//cbc:InvoiceTypeCode')
  assert_equal invoice_type.first.content, @invoice.document_type
end

test 'has a correlative' do
  tags = @parsed_xml.xpath('//cbc:ID')
  correlative = tags.first
  assert_equal correlative.parent.name, 'Invoice'
  assert_equal correlative.content, @invoice.document_number
end

test 'has a customer' do
  customer = @parsed_xml.xpath('//cac:AccountingCustomerParty')
  assert_equal customer.count, 1
end

test 'has at least one item' do
  item = @parsed_xml.xpath('//cac:InvoiceLine')
  assert item.count.positive?
end

test 'has total by kind of sale' do
  tag = '//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/sac:AdditionalInformation'
  additional_info = @parsed_xml.xpath(tag)
  assert additional_info.count.positive?
  assert_equal additional_info.first.children.count, 1
  amount_tag = '//sac:AdditionalMonetaryTotal/cbc:PayableAmount'
  assert_equal additional_info.xpath(amount_tag).first.content.to_f, 200.to_f
end

test 'has total tag' do
  total = @parsed_xml.xpath('//cac:LegalMonetaryTotal')
  assert total.count.positive?
end

test '#calculate_tax_totals' do
  tax = FactoryBot.build(:tax, amount: 15)
  invoice = FactoryBot.build(:invoice)
  2.times do
    invoice.items << FactoryBot.build(:item, taxes: [tax])
  end
  invoice.calculate_tax_totals
  tax_totals = invoice.instance_variable_get('@tax_totals')
  assert_equal tax_totals.count, 1
  assert_equal tax_totals[:igv], 300
end

test '#get_total_igv_code' do
  invoice = SunatInvoice::Invoice.new
  assert_equal invoice.get_total_igv_code('11'), '1004'
  assert_equal invoice.get_total_igv_code('15'), '1004'
  assert_equal invoice.get_total_igv_code('20'), '1003'
  assert_equal invoice.get_total_igv_code('32'), '1002'
  assert invoice.get_total_igv_code('42').nil?
end
