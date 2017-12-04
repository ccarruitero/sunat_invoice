# frozen_string_literal: false

module SunatInvoice
  module Utils
    @namespace_path = 'urn:oasis:names:specification:ubl:schema:xsd'
    @sunat_namespace_path = 'urn:sunat:names:specification:ubl:peru:schema:xsd'

    UBL_NAMESPACES = {
      'xmlns' => "#{@namespace_path}:Invoice-2",
      'xmlns:cac' => "#{@namespace_path}:CommonAggregateComponents-2",
      'xmlns:cbc' => "#{@namespace_path}:CommonBasicComponents-2",
      'xmlns:ccts' => 'urn:un:unece:uncefact:documentation:2',
      'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#',
      'xmlns:ext' => "#{@namespace_path}:CommonExtensionComponents-2",
      'xmlns:qdt' => "#{@namespace_path}:QualifiedDatatypes-2",
      'xmlns:sac' => "#{@sunat_namespace_path}:SunatAggregateComponents-1",
      'xmlns:udt' => 'urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
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
