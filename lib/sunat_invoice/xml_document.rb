# frozen_string_literal: false

require_relative 'model'
require_relative 'utils'

module SunatInvoice
  class XmlDocument < Model
    include Utils

    attr_accessor :date, :provider, :signature, :currency, :lines

    UBL_VERSION = '2.0'.freeze
    CUSTOMIZATION = '1.0'.freeze

    def initialize(*args)
      super(*args)
      @date ||= Date.today
    end

    def build_xml(&block)
      Nokogiri::XML::Builder.new do |xml|
        xml.send(root_name, namespaces) do
          build_ext(xml)
          xml['cbc'].UBLVersionID UBL_VERSION
          xml['cbc'].CustomizationID CUSTOMIZATION
          yield(xml) if block
        end
      end
    end

    def build_ext(xml, &block)
      xml['ext'].UBLExtensions do
        yield(xml) if block
        @signature.signature_ext(xml)
      end
    end

    def build_number(xml)
      xml['cbc'].ID document_number
    end

    def formatted_date(date)
      date.strftime('%Y-%m-%d')
    end

    def build_lines_xml(xml)
      lines&.each_with_index do |line, index|
        line.xml(xml, index, currency)
      end
    end
  end
end
