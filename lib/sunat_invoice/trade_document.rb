# frozen_string_literal: false

require_relative 'tax'
require_relative 'trade_calculations'

module SunatInvoice
  class TradeDocument < XmlDocument
    include TradeCalculations

    attr_accessor :customer, :document_number, :document_type, :discount

    # total for document (sale totals + taxes - discounts)
    attr_reader :total

    # a hash with taxes totals by tax type
    attr_reader :taxes_totals

    # a hash with totals without taxes for any kind of sale
    attr_reader :sale_totals

    INVOICE_TYPES = %w[01 03].freeze

    def operation
      :send_bill
    end

    def document_name
      "#{@provider.ruc}-#{document_type}-#{document_number}"
    end

    private

    def invoice?
      INVOICE_TYPES.include?(document_type)
    end

    def build_document_data(xml)
      build_number(xml)
      xml['cbc'].IssueDate formatted_date(date)
      xml['cbc'].InvoiceTypeCode document_type if invoice?
      xml['cbc'].DocumentCurrencyCode currency
    end

    def build_ext(xml)
      super(xml) do |xml_|
        build_sale_totals(xml_)
      end
    end

    def build_sale_totals(xml)
      prepare_totals
      ubl_ext(xml) do
        xml['sac'].AdditionalInformation do
          @sale_totals&.each do |code, amount|
            build_monetary_total(xml, code, amount)
          end
          build_monetary_total(xml, '2005', discount) if discount
        end
      end
    end

    def build_monetary_total(xml, code, amount)
      xml['sac'].AdditionalMonetaryTotal do
        xml['cbc'].ID code
        amount_xml(xml['cbc'], 'PayableAmount', amount, @currency)
      end
    end

    def build_common_content(xml)
      @signature.signer_data(xml)
      @provider.info(xml)
      @customer.info(xml)
      build_taxes_totals(xml)
      build_total(xml)
      build_lines_xml(xml)
    end

    def build_taxes_totals(xml)
      @taxes_totals.each do |key, value|
        SunatInvoice::Tax.new(tax_type: key, amount: value).xml(xml, @currency)
      end
    end

    def total_tag
      'LegalMonetaryTotal'
    end

    def build_total(xml)
      xml['cac'].send(total_tag) do
        amount_xml(xml['cbc'], 'PayableAmount', @total, @currency)
      end
    end
  end
end
