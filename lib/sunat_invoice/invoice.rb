# frozen_string_literal: false

require_relative 'provider'
require_relative 'customer'
require_relative 'signature'
require_relative 'tax'
require_relative 'catalogs'

module SunatInvoice
  class Invoice < XmlDocument
    attr_accessor :document_type, :document_number, :items

    def initialize(*args)
      super(*args)
      opts = args[0] || {}
      init_defaults(opts)
    end

    def init_defaults(opts)
      parties_default(opts)
      @date ||= Date.today
      @document_type = opts[:document_type] || '01'
      @document_number = opts[:document_number] || 'F001-1'
      @currency = opts[:currency] || 'PEN'
      @items ||= []
      @signature = SunatInvoice::Signature.new(provider: @provider)
    end

    def parties_default(opts)
      @provider = opts[:provider] || SunatInvoice::Provider.new
      @customer = opts[:customer] || SunatInvoice::Customer.new
    end

    def xml
      prepare_totals

      build = build_xml('Invoice') do |xml|
        build_invoice_data(xml)
        @signature.signer_data(xml)
        @provider.info(xml)
        @customer.info(xml)
        build_tax_totals(xml)
        build_total(xml)
        build_items(xml)
      end

      invoice_xml = build.to_xml
      @signature.sign(invoice_xml)
    end

    def prepare_totals
      calculate_tax_totals
      calculate_sale_totals
      calculate_total
    end

    def calculate_total
      # calculate invoice total
      @total = 0
      @total += @tax_totals.values.sum
      @total += @sale_totals.values.sum
    end

    def calculate_sale_totals
      @sale_totals = {}
      # get bi totals according kind of sale (gravado, inafecto, exonerado ..)
      items.each do |item|
        # TODO: I think in most cases only be one tax for item, but should
        #       handle more cases
        total_code = get_total_code(item.taxes.first)
        if total_code
          @sale_totals[total_code] = 0 unless @sale_totals[total_code]
          @sale_totals[total_code] += item.bi_value
        end
      end
    end

    def calculate_tax_totals
      # concat item's sale_taxes
      @tax_totals = {}
      taxes = items.map(&:sale_taxes).flatten
      taxes.each do |tax|
        @tax_totals[tax.keys.first] ||= 0
        @tax_totals[tax.keys.first] += tax.values.sum
      end
    end

    def build_ext(xml)
      super(xml) do |xml_|
        build_sale_totals(xml_)
      end
    end

    def build_invoice_data(xml)
      build_number(xml)
      xml['cbc'].IssueDate formated_date(date)
      xml['cbc'].InvoiceTypeCode @document_type
      xml['cbc'].DocumentCurrencyCode @currency
    end

    def build_items(xml)
      items.each_with_index do |item, index|
        item.xml(xml, index, @currency)
      end
    end

    def document_name
      "#{@provider.ruc}-#{document_type}-#{document_number}"
    end

    def build_tax_totals(xml)
      @tax_totals.each do |key, value|
        SunatInvoice::Tax.new(tax_type: key, amount: value).xml(xml, @currency)
      end
    end

    def build_sale_totals(xml)
      ubl_ext(xml) do
        xml['sac'].AdditionalInformation do
          @sale_totals.each do |code, amount|
            xml['sac'].AdditionalMonetaryTotal do
              xml['cbc'].ID code
              amount_xml(xml['cbc'], 'PayableAmount', amount, @currency)
            end
          end
        end
      end
    end

    def build_total(xml)
      xml['cac'].LegalMonetaryTotal do
        amount_xml(xml['cbc'], 'PayableAmount', @total, @currency)
      end
    end

    def add_item(item)
      items << item if item.is_a?(SunatInvoice::Item)
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
