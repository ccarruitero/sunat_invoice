# frozen_string_literal: false

require_relative 'trade_document'

module SunatInvoice
  class CreditNote < TradeDocument
    # * date - issued date
    # * ref_document_number - serial and number of document affected
    # * ref_document_type - type of document affected
    # * response_code - reason for which credit note is issued (CATALOG_09)
    # * description - description of reason
    # * document_type - should be '07' according CATALOG_01
    # * document_number - serial and correlative number of document
    # * provider - a SunatInvoice::Provider instance
    # * customer - a SunatInvoice::Customer instance
    # * signature - a SunatInvoice::Signature instance
    # * lines - array of SunatInvoice::CreditNoteLine instances

    attr_accessor :ref_document_number, :ref_document_type, :response_code,
                  :description

    def xml
      build = build_xml do |xml|
        build_document_data(xml)
        build_discrepancy_response(xml)
        build_billing_reference(xml)
        build_common_content(xml)
      end
      @signature.sign(build.to_xml)
    end

    private

    def root_name
      'CreditNote'
    end

    def namespaces
      CREDIT_NOTE_NAMESPACES.merge(TRADE_NAMESPACES)
    end

    def build_discrepancy_response(xml)
      xml['cac'].DiscrepancyResponse do
        xml['cbc'].ReferenceID ref_document_number
        xml['cbc'].ResponseCode response_code # CATALOG_09
        xml['cbc'].Description description
      end
    end

    def build_billing_reference(xml)
      xml['cac'].BillingReference do
        xml['cac'].InvoiceDocumentReference do
          xml['cbc'].ID ref_document_number
          xml['cbc'].DocumentTypeCode ref_document_type
        end
      end
    end
  end
end
