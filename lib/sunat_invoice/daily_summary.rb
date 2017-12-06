# frozen_string_literal: true

module SunatInvoice
  class DailySummary < XmlDocument
    attr_accessor :reference_date, :lines

    def namespaces
      SUMMARY_NAMESPACES
    end

    def xml
      build = build_xml('SummaryDocuments') do |xml|
        build_number(xml)
        build_summary_info(xml)
        @signature.signer_data(xml)
        @provider.info(xml)
        build_lines_xml(xml)
      end
      @signature.sign(build.to_xml)
    end

    def operation
      :send_summary
    end

    def document_name
      "#{@provider.ruc}-#{document_number}-1"
    end

    private

    def document_number
      formated = date.strftime('%Y%m%d') #  YYYYMMDD
      "RC-#{formated}"
    end

    def build_summary_info(xml)
      xml['cbc'].ReferenceDate formated_date(reference_date)
      xml['cbc'].IssueDate formated_date(date)
    end

    def build_lines_xml(xml)
      lines&.each_with_index do |line, index|
        line.xml(xml, index, currency)
      end
    end
  end
end
