# frozen_string_literal: true

module SunatInvoice
  class DailySummary < XmlDocument
    attr_accessor :reference_date

    def xml
      build = build_xml('SummaryDocuments') do |xml|
        build_number(xml)
        xml['cbc'].ReferenceDate formated_date(reference_date)
        xml['cbc'].IssueDate formated_date(date)
        @signature.signer_data(xml)
        @provider.info(xml)
      end
      @signature.sign(build.to_xml)
    end

    def document_number
      formated = date.strftime('%Y%m%d') #  YYYYMMDD
      "RC-#{formated}"
    end
  end
end
