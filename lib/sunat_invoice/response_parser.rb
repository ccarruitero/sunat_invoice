# frozen_string_literal: false

module SunatInvoice
  class ResponseParser
    attr_reader :cdr, :status_code, :document_number, :message, :ticket

    STATUS_CODES = {
      0 => 'process success',
      99 => 'in process',
      98 => 'process with errors'
    }.freeze

    ALLOWED_PARSERS = ['invoice', 'summary'].freeze

    def initialize(body, parser_type)
      # body: SOAP body as a Hash. Typically Savon Response body.
      # parser_type: kind of parser to use.
      send("parse_#{parser_type}", body)
    end

    private

    def parse_invoice(body)
      encrypted = body[:send_bill_response][:application_response]
      decoded = Base64.decode64(encrypted)
      Zip::InputStream.open(StringIO.new(decoded)) do |io|
        while (entry = io.get_next_entry)
          parse_xml(io.read) if entry.name.include?('.xml')
        end
      end
    end

    def parse_xml(cdr_xml)
      @cdr = Nokogiri::XML(cdr_xml)
      response_node = @cdr.at('//cac:DocumentResponse/cac:Response')
      @status_code = response_node.at('//cbc:ResponseCode').content
      @document_number = response_node.at('//cbc:ReferenceID').content
      @message = response_node.at('//cbc:Description').content
    end

    def parse_summary(body)
      @ticket = body[:send_summary_response][:ticket]
    end
  end
end
