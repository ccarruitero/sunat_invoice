# frozen_string_literal: false

require_relative 'tax'

module SunatInvoice
  class TradeDocument < XmlDocument
    attr_accessor :customer, :document_number

    def operation
      :send_bill
    end

    private

    def build_document_data(xml)
      build_number(xml)
      xml['cbc'].IssueDate formatted_date(date)
      xml['cbc'].InvoiceTypeCode document_type if document_type
      xml['cbc'].DocumentCurrencyCode currency
    end

    def build_ext(xml)
      super(xml) do |xml_|
        build_sale_totals(xml_)
      end
    end

    def build_sale_totals(xml)
      ubl_ext(xml) do
        xml['sac'].AdditionalInformation do
          @sale_totals&.each do |code, amount|
            xml['sac'].AdditionalMonetaryTotal do
              xml['cbc'].ID code
              amount_xml(xml['cbc'], 'PayableAmount', amount, @currency)
            end
          end
        end
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

    def build_total(xml)
      xml['cac'].LegalMonetaryTotal do
        amount_xml(xml['cbc'], 'PayableAmount', @total, @currency)
      end
    end
  end
end
