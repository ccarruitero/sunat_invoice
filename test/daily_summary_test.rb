# frozen_string_literal: false

require_relative 'helper'

setup do
  provider = FactoryBot.build(:provider)
  signature = FactoryBot.build(:signature, provider: provider)
  ref_date = Date.today - 1
  line = SunatInvoice::SummaryLine.new(document_type: '03',
                                       document_serial: 'BD56',
                                       start_document_number: 231,
                                       end_document_number: 239,
                                       taxable: 200)
  summary = SunatInvoice::DailySummary.new(provider: provider,
                                           signature: signature,
                                           reference_date: ref_date,
                                           currency: 'PEN',
                                           lines: [line])
  @parsed_xml = Nokogiri::XML(summary.xml, &:noblanks)
end

test 'start with SummaryDocuments tag' do
  assert_equal @parsed_xml.root.name, 'SummaryDocuments'
end
