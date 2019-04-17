# frozen_string_literal: false

module SunatInvoice
  class InvalidResponseParser < StandardError; end

  class ResponseParser
    attr_reader :cdr, :status_code, :document_number, :message, :ticket

    STATUS_CODES = {
      0 => 'process success',
      99 => 'in process',
      98 => 'process with errors'
    }.freeze

    ALLOWED_PARSERS = %w[invoice summary status].freeze
    VALID_PROCESS = %w[0].freeze
    IN_PROCESS = %w[99].freeze

    def initialize(body, parser_type)
      # body: SOAP body as a Hash. Typically Savon Response body.
      # parser_type: kind of parser to use.
      raise InvalidResponseParser unless ALLOWED_PARSERS.include?(parser_type)
      send("parse_#{parser_type}", body)
    end

    private

    def parse_invoice(body)
      encrypted_zip = body[:send_bill_response][:application_response]
      decrypt_zip(encrypted_zip)
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

    def parse_status(body)
      status_hash = body[:get_status_response][:status]
      @status_code = status_hash[:status_code]
      if VALID_PROCESS.include?(status_code)
        encrypted_zip = status_hash[:content]
        decrypt_zip(encrypted_zip)
      elsif IN_PROCESS.include?(status_code)
        @message = 'Your ticket is still in process'
      else
        @message = status_hash[:content]
      end
    end

    def decrypt_zip(encrypted_zip)
      decoded = Base64.decode64(encrypted_zip)
      Zip::InputStream.open(StringIO.new(decoded)) do |io|
        while (entry = io.get_next_entry)
          parse_xml(io.read) if entry.name.include?('.xml')
        end
      end
    end
  end
end
