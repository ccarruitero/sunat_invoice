# frozen_string_literal: false
require_relative 'helper'
include SunatInvoice

setup do
  @provider = SunatInvoice::Provider.new(
    signature: FFaker::LoremCN.paragraph,
    ruc: FFaker::IdentificationMX.curp,
    name: FFaker::Company.name,
    document_type: 6,
    ubigeo: '14',
    street: '',
    zone: '',
    province: '',
    department: '',
    district: '',
    country_code: ''
  )
  customer = SunatInvoice::Customer.new(
    ruc: FFaker::IdentificationMX.curp,
    name: FFaker::Company.name,
    document_type: 6
  )
  @invoice = SunatInvoice::Invoice.new(@provider, customer)
  @invoice.items << SunatInvoice::Item.new
  @parsed_xml = Nokogiri::XML(@invoice.xml, &:noblanks)
end

test 'is not broken' do
  assert !@invoice.nil?
end

test 'has namespaces' do
  cbc = 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2'
  namespaces = @parsed_xml.css('Invoice').first.namespaces
  assert namespaces['xmlns:cbc'] == cbc
end

test 'xml start with invoice tag' do
  assert @parsed_xml.root.name == 'Invoice'
end

test 'has a date' do
  date = @parsed_xml.xpath('//cbc:IssueDate')
  assert date.first.content == DateTime.now.strftime('%Y-%m-%d')
end

test 'has a signature' do
  # /ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature
  signature = @parsed_xml.xpath('//ext:UBLExtensions/ext:UBLExtension')
  assert signature.xpath('//ext:ExtensionContent/ds:Signature').count == 1

  # /cac:Signature
  signature = @parsed_xml.xpath('//cac:Signature')
  assert signature.count == 1
end

test 'has a registration name' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty/cac:Party')
  name = provider.xpath('//cac:PartyLegalEntity/cbc:RegistrationName')
  assert name.first.content == @provider.name
end

test 'has a name' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty/cac:Party')
  name = provider.xpath('//cac:PartyName/cbc:Name')
  assert name.first.content == @provider.name
end

test 'has an address' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty/cac:Party')
  ubigeo = provider.xpath('//cac:PostalAddress/cbc:ID')
  assert ubigeo.first.content == @provider.ubigeo

  street = provider.xpath('//cac:PostalAddress/cbc:StreetName')
  assert street.first.content == @provider.street

  urbanizacion = provider.xpath('//cac:PostalAddress/cbc:CitySubdivisionName')
  assert urbanizacion.first.content == @provider.zone

  provincia = provider.xpath('//cac:PostalAddress/cbc:CityName')
  assert provincia.first.content == @provider.province

  # Departamento
  departamento = provider.xpath('//cac:PostalAddress/cbc:CountrySubentity')
  assert departamento.first.content == @provider.department

  # Distrito
  distrito = provider.xpath('//cac:PostalAddress/cbc:District')
  assert distrito.first.content == @provider.district

  country_code_path = '//cac:PostalAddress/cac:Country/cbc:IdentificationCode'
  country_code = provider.xpath(country_code_path)
  assert country_code.first.content == @provider.country_code.to_s
end

test 'has a ruc' do
  provider = @parsed_xml.xpath('//cac:AccountingSupplierParty')
  ruc = provider.xpath('//cbc:CustomerAssignedAccountID')
  assert ruc.first.content == @provider.ruc

  document_type = provider.xpath('//cbc:AdditionalAccountID')
  assert document_type.first.content == @provider.document_type.to_s
end

test 'has an invoice type' do
  invoice_type = @parsed_xml.xpath('//cbc:InvoiceTypeCode')
  assert invoice_type.first.content == @invoice.document_type
end

test 'has a correlative' do
  tags = @parsed_xml.xpath('//cbc:ID')
  correlative = tags.first
  assert correlative.parent.name == 'Invoice'
  assert correlative.content == @invoice.document_number
end

test 'has a customer' do
  customer = @parsed_xml.xpath('//cac:AccountingCustomerParty')
  assert customer.count == 1
end

test 'has at least one item' do
  item = @parsed_xml.xpath('//cac:InvoiceLine')
  assert item.count.positive?
end

test '#calculate_tax_totals' do
  tax = SunatInvoice::Tax.new(amount: 15, tax_type: :igv)
  2.times do
    @invoice.items << SunatInvoice::Item.new(taxes: [tax])
  end
  @invoice.calculate_tax_totals
  tax_totals = @invoice.instance_variable_get('@tax_totals')
  assert tax_totals.count == 1
  assert tax_totals[:igv] == 30
end

test '#get_total_igv_code' do
  invoice = SunatInvoice::Invoice.new
  assert invoice.get_total_igv_code('11') == '1004'
  assert invoice.get_total_igv_code('15') == '1004'
  assert invoice.get_total_igv_code('20') == '1003'
  assert invoice.get_total_igv_code('32') == '1002'
  assert invoice.get_total_igv_code('42') == nil
end
