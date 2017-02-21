# frozen_string_literal: false
require_relative 'utils'
require_relative 'provider'
require_relative 'customer'

module SunatInvoice
  class Invoice
    include Utils

    BASIC_FIELDS = [].freeze

    def initialize(provider = nil, customer = nil, date = nil)
      # @signature_path = config.signature_path
      # @signature_id =
      @provider = provider || SunatInvoice::Provider.new
      @customer = customer || SunatInvoice::Customer.new
      @date = date || DateTime.now.strftime('%Y-%m-%d')
    end

    def xml
      parent_xml = Gyoku.xml(invoice: xml_hash)
      child_xml = Gyoku.xml(ubl_ext('sac:AdditionalInformation' => {
                                      # TODO: total taxs
                                    }))
      concat_xml(parent_xml, child_xml, 'cac:InvoiceLine')
      Nokogiri.XML(parent_xml).to_xml
    end

    def xml_hash
      main_xml.merge(@customer.scheme)
    end

    def signate_info
      {
        'ds:CanonicalizationMethod/': {
          '@Algorithm': 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments'
        },
        'ds:SignatureMethod/': {
          '@Algorithm': 'http://www.w3.org/2000/09/xmldsig#dsa-sha1'
        },
        'ds:Reference': {
          '@URI': '',
          content!: @provider.signature_reference
        }
      }
    end

    def digital_signature
      Gyoku.xml(ubl_ext(@providersignature_hash))
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

    def provider_xml
      concat_xml(@provider.info, @provider.address, 'cac:PostalAddress')
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
