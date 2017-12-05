# frozen_string_literal: false

require_relative 'model'
require_relative 'utils'

module SunatInvoice
  class XmlDocument < Model
    include Utils

    UBL_VERSION = '2.0'.freeze
    CUSTOMIZATION = '1.0'.freeze

    def build_xml(root)
      Nokogiri::XML::Builder.new do |xml|
        xml.send(root, UBL_NAMESPACES) do
          build_ext(xml)
          xml['cbc'].UBLVersionID UBL_VERSION
          xml['cbc'].CustomizationID CUSTOMIZATION
          yield(xml)
        end
      end
    end

    def build_ext(xml)
      xml['ext'].UBLExtensions do
        yield(xml)
        @signature.signature_ext(xml)
      end
    end
  end
end
