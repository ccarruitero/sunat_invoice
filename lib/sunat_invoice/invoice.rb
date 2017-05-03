# frozen_string_literal: false
require_relative 'utils'
require_relative 'provider'
require_relative 'customer'

module SunatInvoice
  class Invoice
    include Utils

    attr_accessor :document_type, :document_number

    def initialize(*args)
      @provider = args[0] || SunatInvoice::Provider.new
      @customer = args[1] || SunatInvoice::Customer.new
      @date = args[2] || DateTime.now.strftime('%Y-%m-%d')
      @document_type = args[3] || '01'
      @document_number = args[4] || 'F001-1'
    end

    def invoice_info
      {
        'cbc:InvoiceTypeCode': @document_type,
        'cbc:ID': @document_number
      }
    end

    def xml
      parent_xml = Gyoku.xml(xml_hash)
      # child_xml = Gyoku.xml(ubl_ext('sac:AdditionalInformation' => {}))
      info_xml = Gyoku.xml(invoice_info)
      # concat_xml(parent_xml, child_xml, 'cac:InvoiceLine')
      concat_xml(parent_xml, @provider.xml, 'cac:Signature')
      concat_xml(parent_xml, digital_signature, 'cbc:IssueDate')
      concat_xml(parent_xml, info_xml, 'cbc:IssueDate')

      build = Nokogiri::XML::Builder.new do |xml|
        xml.Invoice(UBL_NAMESPACES) { xml << parent_xml }
      end
      build.to_xml
    end

    def xml_hash
      main_xml.merge(@customer.scheme)
    end

    def digital_signature
      Gyoku.xml(ubl_ext(@provider.signature_hash))
    end

    def main_xml
      {
        'cbc:IssueDate' => @date,
        # '': digital_signature
        'cac:Signature' => {
          'cbc:ID' => @provider.signature,
          'cac:SignatoryParty' => {
            'cac:PartyIdentification' => {
              'cbc:ID' => @provider.ruc
            },
            'cac:PartyName' => {
              'cbc:Name' => @provider.name
            }
          },
          'cac:DigitalSignatureAttachment' => {
            'cac:ExternalReference' => {
              'cbc:URI' => ''
            }
          }
        }
      }
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
