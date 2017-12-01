# frozen_string_literal: false

module SunatInvoice
  module Utils
    @namespace_path = 'urn:oasis:names:specification:ubl:schema:xsd'
    @sunat_namespace_path = 'urn:sunat:names:specification:ubl:peru:schema:xsd'

    UBL_NAMESPACES = {
      'xmlns' => "#{@namespace_path}:Invoice-2",
      'xmlns:cac' => "#{@namespace_path}:CommonAggregateComponents-2",
      'xmlns:cbc' => "#{@namespace_path}:CommonBasicComponents-2",
      'xmlns:ext' => "#{@namespace_path}:CommonExtensionComponents-2",
      'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#',
      'xmlns:sac' => "#{@sunat_namespace_path}:SunatAggregateComponents-1",
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'xsi:schemaLocation' => 'urn:sunat:names:specification:ubl:peru:schema:xsd:InvoiceSummary-1 D:\UBL_SUNAT\SUNAT_xml_20110112\20110112\xsd\maindoc\UBLPE-InvoiceSummary-1.0.xsd'
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
