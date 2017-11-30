# frozen_string_literal: false
require_relative 'utils'
require_relative 'provider'
require_relative 'customer'
require_relative 'signature'
require_relative 'tax'

module SunatInvoice
  class Invoice
    include Utils

    attr_accessor :document_type, :document_number, :items

    def initialize(*args)
      @provider = args[0] || SunatInvoice::Provider.new
      @customer = args[1] || SunatInvoice::Customer.new
      @date = args[2] || DateTime.now.strftime('%Y-%m-%d')
      @document_type = args[3] || '01'
      @document_number = args[4] || 'F001-1'
      @items = []
      @signature = SunatInvoice::Signature.new(provider: @provider)
      @currency = 'PEN'
      @totals = []
      @tax_totals = {}
    end

    def xml
      prepare_totals

      build = Nokogiri::XML::Builder.new do |xml|
        xml.Invoice(UBL_NAMESPACES) do
          xml['cbc'].IssueDate @date
          xml['cbc'].InvoiceTypeCode @document_type
          xml['cbc'].ID @document_number
          xml['cbc'].DocumentCurrencyCode @currency

          @signature.signer_data(xml)
          xml['ext'].UBLExtensions do
            @signature.signature_ext(xml)
          end
          @provider.info(xml)
          @customer.info(xml)
          build_items(xml)
          build_tax_totals(xml)
        end
      end
      build.to_xml
    end

    def prepare_totals
      calculate_tax_totals
    end

    def calculate_tax_totals
      taxes = items.map(&:taxes).flatten
      taxes.each do |tax|
        @tax_totals[tax.tax_type] = 0 unless @tax_totals[tax.tax_type]
        @tax_totals[tax.tax_type] += tax.amount
      end
    end

    def build_items(xml)
      items.each_with_index do |item, index|
        item.xml(xml, index)
      end
    end

    def build_tax_totals(xml)
      @tax_totals.each do |key, value|
        SunatInvoice::Tax.new(tax_type: key, amount: value).xml(xml)
      end
    end

    def add_item(item)
      items << item if item.is_a?(SunatInvoice::Item)
    end

    def attributes
      {
        attributes!: {
          'cbc:InvoicedQuantity' => { '@unitCode' => :unit },
          'cbc:PriceAmount' => { '@currencyID' => :currency }, # PEN
          'cbc:TaxAmount' => { '@currencyID' => :currency }, # PEN
          'cbc:PayableAmount' => { '@currencyID' => :currency }, # PEN
          'cbc:LineExtensionAmount' => { '@currencyID' => :currency }, # PEN
          'cbc:ChargeTotalAmount' => { '@currencyID' => :currency }, # PEN
        }
      }
    end
  end
end
