# frozen_string_literal: false

require_relative 'provider'
require_relative 'customer'
require_relative 'signature'
require_relative 'catalogs'
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
      prepare_totals

      build = build_xml('Invoice') do |xml|
        build_document_data(xml)
        build_common_content(xml)
      end

      invoice_xml = build.to_xml
      @signature.sign(invoice_xml)
    end

    def prepare_totals
      calculate_taxes_totals
      calculate_sale_totals
      calculate_total
    end

    def calculate_total
      # calculate invoice total
      @total = 0
      @total += @taxes_totals.values.sum
      @total += @sale_totals.values.sum
    end

    def calculate_sale_totals
      @sale_totals = {}
      # get bi totals according kind of sale (gravado, inafecto, exonerado ..)
      lines.each do |item|
        # TODO: I think in most cases only be one tax for item, but should
        #       handle more cases
        total_code = get_total_code(item.taxes.first)
        if total_code
          @sale_totals[total_code] = 0 unless @sale_totals[total_code]
          @sale_totals[total_code] += item.bi_value
        end
      end
    end

    def calculate_taxes_totals
      # concat item's sale_taxes
      @taxes_totals = {}
      taxes = lines.map(&:sale_taxes).flatten
      taxes.each do |tax|
        @taxes_totals[tax.keys.first] ||= 0
        @taxes_totals[tax.keys.first] += tax.values.sum
      end
    end

    def document_name
      "#{@provider.ruc}-#{document_type}-#{document_number}"
    end

    def get_total_code(tax)
      return unless tax
      case tax.tax_type
      # TODO: :isc
      when :igv
        get_total_igv_code(tax.tax_exemption_reason)
      end
    end

    def get_total_igv_code(exemption_reason)
      if Catalogs::CATALOG_07.first == exemption_reason
        Catalogs::CATALOG_14.first
      elsif Catalogs::CATALOG_07[1..6].include?(exemption_reason)
        Catalogs::CATALOG_14[3]
      elsif Catalogs::CATALOG_07[7] == exemption_reason
        Catalogs::CATALOG_14[2]
      elsif Catalogs::CATALOG_07[8..14].include?(exemption_reason)
        Catalogs::CATALOG_14[1]
      end
    end
  end
end
