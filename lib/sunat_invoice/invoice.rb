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
      @date = date
    end

    def xml
      main_xml = Gyoku.xml(invoice: xml_hash)
      concat_xml(main_xml, ubl_ext('sac:AdditionalInformation' => {
                                     # TODO: total taxs
                                   }), 'cac:InvoiceLine')
      Nokogiri.XML(gyoku_xml).to_xml
    end

    def xml_hash
      main_xml.merge(@customer.scheme)
    end

    def main_xml
      {
        'cbc:IssueDate' => @date,
        # digital sign
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

    def provider_address
      {
        'cbc:ID' => @provider.ubigeo,
        'cbc:StreetName' => @provider.street,
        'cbc:CitySubdivisionName' => @provider.urbanizacion,
        'cbc:CityName' => @provider.provincia,
        'cbc:CountrySubentity' => @provider.departamento,
        'cbc:District' => @provider.district,
        'cac:Country' => {
          'cbc:IdentificationCode' => @provider.country_code
        }
      }
    end

    def provider_xml
      concat_xml(provider_info, provider_address, 'cac:PostalAddress')
    end

    def provider_info
      {
        'cac:AccountingSupplierParty' => {
          'cbc:CustomerAssignedAccountID' => @provider.ruc,
          'cbc:AdditionalAccountID' => @provider.document_type,
          'cac:Party' => {
            'cac:PartyName' => {
              'cbc:Name' => @provider.name
            },
            'cac:PostalAddress' => {}
          },
          'cac:PartyLegalEntity' => {
            'cbc:RegistrationName' => @provider.registration_name
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
