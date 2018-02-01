# frozen_string_literal: false

require_relative 'provider'
require_relative 'customer'
require_relative 'signature'
require_relative 'trade_document'

module SunatInvoice
  class Invoice < TradeDocument
    def initialize(*args)
      super(*args)
      opts = args[0] || {}
      init_defaults(opts)
    end

    def init_defaults(opts)
      parties_default(opts)
      @document_type = opts[:document_type] || '01'
      @document_number = opts[:document_number] || 'F001-1'
      @currency = opts[:currency] || 'PEN'
      @lines ||= []
    end

    def parties_default(opts)
      @provider = opts[:provider] || SunatInvoice::Provider.new
      @customer = opts[:customer] || SunatInvoice::Customer.new
    end

    def xml
      build = build_xml do |xml|
        build_document_data(xml)
        build_common_content(xml)
      end

      invoice_xml = build.to_xml
      @signature.sign(invoice_xml)
    end

    private

    def root_name
      'Invoice'
    end

    def namespaces
      INVOICE_NAMESPACES.merge(TRADE_NAMESPACES)
    end
  end
end
