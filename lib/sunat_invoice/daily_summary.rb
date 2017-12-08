# frozen_string_literal: true

module SunatInvoice
  class DailySummary < XmlDocument
    attr_accessor :reference_date

    def namespaces
      DAILY_SUMMARY_NAMESPACES.merge(SUMMARY_NAMESPACES)
    end

    def xml
      build = build_xml do |xml|
        build_number(xml)
        build_summary_info(xml)
        @signature.signer_data(xml)
        @provider.info(xml, false)
        build_lines_xml(xml)
      end
      @signature.sign(build.to_xml)
    end

    def operation
      :send_summary
    end

    def document_name
      "#{@provider.ruc}-#{document_number}"
    end

    private

    def root_name
      'SummaryDocuments'
    end

    def document_number
      formatted = date.strftime('%Y%m%d') #  YYYYMMDD
      "RC-#{formatted}-1"
    end

    def build_summary_info(xml)
      xml['cbc'].ReferenceDate formatted_date(reference_date)
      xml['cbc'].IssueDate formatted_date(date)
    end
  end
end
