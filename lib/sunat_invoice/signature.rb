# frozen_string_literal: true
require_relative 'model'
require_relative 'utils'

module SunatInvoice
  class Signature < Model
    include Utils

    C14N_ALGORITHM            = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
    DIGEST_ALGORITHM          = 'http://www.w3.org/2000/09/xmldsig#sha1'
    SIGNATURE_ALGORITHM       = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
    TRANSFORMATION_ALGORITHM  = 'http://www.w3.org/2000/09/xmldsig#enveloped- signature'

    attr_accessor :provider

    def signer_data(xml)
      xml['cac'].Signature do
        xml['cbc'].ID provider.signature_id
        xml['cac'].SignatoryParty do
          xml['cac'].PartyIdentification do
            xml['cbc'].ID provider.ruc
          end
          xml['cac'].PartyName do
            xml['cbc'].Name provider.name
          end
        end
        xml['cac'].DigitalSignatureAttachment do
          xml['cac'].ExternalReference do
            xml['cbc'].URI "##{provider.uri}"
          end
        end
      end
    end

    def signature_ext(xml)
      ubl_ext(xml) do
        xml['ds'].Signature(Id: provider.signature_id) do
          signed_info xml
          signature_value xml
        end
      end
    end

    def signed_info(xml)
      xml['ds'].SignedInfo do
        xml['ds'].CanonicalizationMethod Algorithm: C14N_ALGORITHM
        xml['ds'].SignatureMethod Algorithm: SIGNATURE_ALGORITHM
        xml['ds'].Reference URI: ''
        xml['ds'].Transforms do
          xml['ds'].Transform Algorithm: TRANSFORMATION_ALGORITHM
        end
        xml['ds'].DigestMethod(Algorithm: DIGEST_ALGORITHM)
        xml['ds'].DigestValue provider.signature_digest
      end
    end

    def signature_value(xml)
      xml['ds'].SignatureValue provider.signature
      xml['ds'].KeyInfo do
        xml['ds'].X509Data do
          xml['ds'].X509Certificate provider.certificate
        end
      end
    end
  end
end
