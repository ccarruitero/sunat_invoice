# frozen_string_literal: false

module SunatInvoice
  module Utils
    @namespace_path = 'urn:oasis:names:specification:ubl:schema:xsd'
    @sunat_namespace_path = 'urn:sunat:names:specification:ubl:peru:schema:xsd'
    @un_namespace_path = 'urn:un:unece:uncefact:data:specification'

    COMMON_NAMESPACES = {
      cac: "#{@namespace_path}:CommonAggregateComponents-2",
      cbc: "#{@namespace_path}:CommonBasicComponents-2",
      ds: 'http://www.w3.org/2000/09/xmldsig#',
      ext: "#{@namespace_path}:CommonExtensionComponents-2",
      sac: "#{@sunat_namespace_path}:SunatAggregateComponents-1",
      xsi: 'http://www.w3.org/2001/XMLSchema-instance'
    }.freeze

    TRADE_NAMESPACES = {
      'xmlns:cac' => COMMON_NAMESPACES[:cac],
      'xmlns:cbc' => COMMON_NAMESPACES[:cbc],
      'xmlns:ccts' => 'urn:un:unece:uncefact:documentation:2',
      'xmlns:ds' => COMMON_NAMESPACES[:ds],
      'xmlns:ext' => COMMON_NAMESPACES[:ext],
      'xmlns:qdt' => "#{@namespace_path}:QualifiedDatatypes-2",
      'xmlns:sac' => COMMON_NAMESPACES[:sac],
      'xmlns:udt' => "#{@un_namespace_path}:UnqualifiedDataTypesSchemaModule:2",
      'xmlns:xsi' => COMMON_NAMESPACES[:xsi]
    }.freeze

    INVOICE_NAMESPACES = {
      'xmlns' => "#{@namespace_path}:Invoice-2"
    }.freeze

    CREDIT_NOTE_NAMESPACES = {
      'xmlns' => "#{@namespace_path}:CreditNote-2"
    }.freeze

    DEBIT_NOTE_NAMESPACES = {
      'xmlns' => "#{@namespace_path}:DebitNote-2"
    }.freeze

    SUMMARY_NAMESPACES = {
      'xmlns:cac' => COMMON_NAMESPACES[:cac],
      'xmlns:cbc' => COMMON_NAMESPACES[:cbc],
      'xmlns:ds' => COMMON_NAMESPACES[:ds],
      'xmlns:ext' => COMMON_NAMESPACES[:ext],
      'xmlns:sac' => COMMON_NAMESPACES[:sac],
      'xmlns:xsi' => COMMON_NAMESPACES[:xsi]
    }.freeze

    DAILY_SUMMARY_NAMESPACES = {
      'xmlns' => "#{@sunat_namespace_path}:SummaryDocuments-1",
      'xsi:schemaLocation' => 'urn:sunat:names:specification:ubl:peru:schema:xsd:InvoiceSummary-1 D:\UBL_SUNAT\SUNAT_xml_20110112\20110112\xsd\maindoc\UBLPE-InvoiceSummary-1.0.xsd'
    }.freeze

    VOIDED_NAMESPACES = {
      'xmlns' => "#{@sunat_namespace_path}:VoidedDocuments-1"
    }.freeze

    def ubl_ext(xml, &block)
      xml['ext'].UBLExtension do
        xml['ext'].ExtensionContent(&block)
      end
    end

    def amount_xml(xml, tag, price, currency)
      xml.send(tag, price, currencyID: currency)
    end
  end
end
