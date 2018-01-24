# frozen_string_literal: true

require_relative 'model'
require_relative 'utils'
require 'xmldsig'
require 'open-uri'

module SunatInvoice
  class Signature < Model
    include Utils

    C14N_ALGORITHM            = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
    DIGEST_ALGORITHM          = 'http://www.w3.org/2000/09/xmldsig#sha1'
    SIGNATURE_ALGORITHM       = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
    TRANSFORMATION_ALGORITHM  = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'

    attr_accessor :provider

    def signer_data(xml)
      xml['cac'].Signature do
        xml['cbc'].ID provider.signature_id
        build_signatory_party(xml)
        build_digital_attachment(xml)
      end
    end

    def build_signatory_party(xml)
      xml['cac'].SignatoryParty do
        xml['cac'].PartyIdentification do
          xml['cbc'].ID provider.ruc
        end
        xml['cac'].PartyName do
          xml['cbc'].Name provider.name
        end
      end
    end

    def build_digital_attachment(xml)
      xml['cac'].DigitalSignatureAttachment do
        xml['cac'].ExternalReference do
          xml['cbc'].URI "##{provider.signature_location_id}"
        end
      end
    end

    def sign(invoice_xml)
      options = { id_attr: provider.signature_location_id }
      doc = Xmldsig::SignedDocument.new(invoice_xml, options)
      doc.sign(private_key)
    end

    def signature_ext(xml)
      ubl_ext(xml) do
        xml['ds'].Signature(Id: provider.signature_location_id) do
          signed_info xml
          signature_value xml
        end
      end
    end

    def signed_info(xml)
      xml['ds'].SignedInfo do
        xml['ds'].CanonicalizationMethod Algorithm: C14N_ALGORITHM
        xml['ds'].SignatureMethod Algorithm: SIGNATURE_ALGORITHM
        xml['ds'].Reference URI: '' do
          build_transforms(xml)
          xml['ds'].DigestMethod Algorithm: DIGEST_ALGORITHM
          xml['ds'].DigestValue
        end
      end
    end

    def build_transforms(xml)
      xml['ds'].Transforms do
        xml['ds'].Transform Algorithm: TRANSFORMATION_ALGORITHM
      end
    end

    def signature_value(xml)
      xml['ds'].SignatureValue
      xml['ds'].KeyInfo do
        xml['ds'].X509Data do
          xml['ds'].X509Certificate encoded_certificate
        end
      end
    end

    private

    def encoded_certificate
      Base64.encode64(certificate.to_der).gsub(/\n/, '')
    end

    def file_content(file)
      open(file) { |f| f.read }
    end

    def private_key
      OpenSSL::PKey::RSA.new(file_content(provider.pk_file))
    end

    def certificate
      OpenSSL::X509::Certificate.new(file_content(provider.cert_file))
    end
  end
end
