# frozen_string_literal: true
require_relative 'tributer'
require_relative 'utils'

module SunatInvoice
  class Provider < Tributer
    include Utils

    attr_accessor :signature, :signature_id, :certificate, :uri

    def address
      {
        'cbc:ID' => @ubigeo,
        'cbc:StreetName' => @street,
        'cbc:CitySubdivisionName' => @zone,
        'cbc:CityName' => @province,
        'cbc:CountrySubentity' => @departament,
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
          content!: signature_reference
        }
      }
    end

    def xml
      Gyoku.xml(info)
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
            'cac:PostalAddress' => address,
            'cac:PartyLegalEntity' => {
              'cbc:RegistrationName' => @name
            }
          }
        }
      }
    end
  end
end
