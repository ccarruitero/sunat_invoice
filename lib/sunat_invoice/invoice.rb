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
      @signature = SunatInvoice::Signature.new(provider: @provider)
    end

    def parties_default(opts)
      @provider = opts[:provider] || SunatInvoice::Provider.new
      @customer = opts[:customer] || SunatInvoice::Customer.new
    end

    def namespaces
      INVOICE_NAMESPACES.merge(TRADE_NAMESPACES)
    end

    def xml
      build = build_xml('Invoice') do |xml|
        build_document_data(xml)
        build_common_content(xml)
      end

      invoice_xml = build.to_xml
      @signature.sign(invoice_xml)
    end

    def document_name
      "#{@provider.ruc}-#{document_type}-#{document_number}"
    end
  end
end
