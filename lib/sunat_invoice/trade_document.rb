# frozen_string_literal: false

module SunatInvoice
  class TradeDocument < XmlDocument
    attr_accessor :customer, :document_number, :items

    def operation
      :send_bill
    end

    private

    def build_document_data(xml)
      build_number(xml)
      xml['cbc'].IssueDate formated_date(date)
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
  end
end
