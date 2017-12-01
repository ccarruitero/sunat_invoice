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

    def placeholder(xml)
      # element for store signature
      ubl_ext(xml)
    end

    def sign(invoice_xml)
      doc = Nokogiri::XML(invoice_xml)
      ext_tag = '//ext:ExtensionContent[not(node())]'

      Nokogiri::XML::Builder.with(doc.at(ext_tag)) do |xml|
        signature_ext(xml, invoice_xml)
      end
      doc.to_xml
    end

    def signature_ext(xml, invoice_xml)
      xml['ds'].Signature(Id: provider.signature_id) do
        signed_info xml, invoice_xml
        signature_value xml
      end
    end

    def signed_info(xml, invoice_xml)
      xml['ds'].SignedInfo do
        xml['ds'].CanonicalizationMethod Algorithm: C14N_ALGORITHM
        xml['ds'].SignatureMethod Algorithm: SIGNATURE_ALGORITHM
        xml['ds'].Reference URI: ''
        xml['ds'].Transforms do
          xml['ds'].Transform Algorithm: TRANSFORMATION_ALGORITHM
        end
        xml['ds'].DigestMethod(Algorithm: DIGEST_ALGORITHM)
        xml['ds'].DigestValue digest(invoice_xml)
      end
    end

    def signature_value(xml)
      info = xml.at('//ds:SignedInfo')
      info_canonicalized = canonicalize(info).to_s
      xml['ds'].SignatureValue sign_info(info_canonicalized)
      xml['ds'].KeyInfo do
        xml['ds'].X509Data do
          xml['ds'].X509Certificate certificate
        end
      end
    end

    private

    def sign_info(text)
      Base64.strict_encode64(private_key.sign(OpenSSL::Digest::SHA1.new, text))
    end

    def digest(text)
      OpenSSL::Digest::SHA1.new.base64digest(text)
    end

    def canonicalize(info)
      info.canonicalize(Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0, ['soap', 'web'])
    end

    def private_key
      OpenSSL::PKey::RSA.new(File.read(provider.pk_file))
    end

    def certificate
      OpenSSL::X509::Certificate.new(File.read(provider.cert_file))
    end
  end
end
