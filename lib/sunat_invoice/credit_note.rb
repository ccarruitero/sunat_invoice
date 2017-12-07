# frozen_string_literal: false

require_relative 'trade_document'

module SunatInvoice
  class CreditNote < TradeDocument
    def xml
      build = build_xml('CreditNote') do |xml|
        build_document_data(xml)
      end
      @signature.sign(build.to_xml)
    end

    private

    def namespaces
      CREDIT_NOTE_NAMESPACES.merge(TRADE_NAMESPACES)
    end
  end
end
