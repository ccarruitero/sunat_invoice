# frozen_string_literal: false
require_relative 'utils'
require_relative 'provider'
require_relative 'customer'
require_relative 'signature'

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
    end

    def xml
      build = Nokogiri::XML::Builder.new do |xml|
        xml.Invoice(UBL_NAMESPACES) do
          xml['cbc'].IssueDate @date
          xml['cbc'].InvoiceTypeCode @document_type
          xml['cbc'].ID @document_number

          @signature.signer_data(xml)
          xml['ext'].UBLExtensions do
            ubl_ext(xml) do
              @signature.signature_ext(xml)
            end
          end
          @provider.info(xml)
          @customer.info(xml)
        end
      end
      build.to_xml
    end

    def xml_hash
      main_xml.merge(@customer.scheme)
    end

    def digital_signature
      Gyoku.xml(ubl_ext(@provider.signature_hash))
    end

    def add_items(xml)
      @items.each do |item|
        xml << item.xml if item.is_a?(SunatInvoice::Item)
      end
    end

    def description_xml
      ubl_ext({})
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
