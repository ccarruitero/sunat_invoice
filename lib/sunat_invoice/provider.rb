# frozen_string_literal: true
require_relative 'tributer'
require_relative 'utils'

module SunatInvoice
  class Provider < Tributer
    include Utils

    attr_accessor :signature, :signature_id, :certificate

    def address
      {
        'cbc:ID' => @ubigeo,
        'cbc:StreetName' => @street,
        'cbc:CitySubdivisionName' => @urbanizacion,
        'cbc:CityName' => @provincia,
        'cbc:CountrySubentity' => @departamento,
        'cbc:District' => @district,
        'cac:Country' => {
          'cbc:IdentificationCode' => @country_code
        }
      }
    end

    def signature_hash
      {
        'ds:Signature': {
          '@Id': @signature_id,
          content!: {
            'ds:SignedInfo': signate_info, # signant er??
            'ds:SignatureValue': @signature,
            'ds:KeyInfo': {
              'ds:X509Data': {
                'ds:X509Certificate': @certificate
              }
            }
          }
        }
      }
    end

    def xml
      concat_xml(Gyoku.xml(info), Gyoku.xml(address), 'cac:PostalAddress')
    end

    def signature_reference
      {
        'ds:Transforms': {
          'ds:Transform/': {
            '@Algorithm': 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
          }
        },
        'ds:DigestMethod/': {
          '@Algorithm': 'http://www.w3.org/2000/09/xmldsig#sha1'
        },
        'ds:DigestValue': ''
      }
    end

    def info
      {
        'cac:AccountingSupplierParty' => {
          'cbc:CustomerAssignedAccountID' => @ruc,
          'cbc:AdditionalAccountID' => @document_type,
          'cac:Party' => {
            'cac:PartyName' => {
              'cbc:Name' => @name
            },
            'cac:PostalAddress' => {},
            'cac:PartyLegalEntity' => {
              'cbc:RegistrationName' => @registration_name
            }
          }
        }
      }
    end
  end
end
