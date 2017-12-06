# frozen_string_literal: false

require_relative 'helper'

setup do
  provider = FactoryBot.build(:provider)
  signature = FactoryBot.build(:signature, provider: provider)
  ref_date = Date.today - 1
  @line = FactoryBot.build(:summary_line)
  summary = SunatInvoice::DailySummary.new(provider: provider,
                                           signature: signature,
                                           reference_date: ref_date,
                                           currency: 'PEN',
                                           lines: [@line])
  @parsed_xml = Nokogiri::XML(summary.xml, &:noblanks)
end

test 'start with SummaryDocuments tag' do
  assert_equal @parsed_xml.root.name, 'SummaryDocuments'
end

test 'line total amount has correct content' do
  total = @parsed_xml.at('//sac:SummaryDocumentsLine/sac:TotalAmount').content
  assert_equal total, @line.total_amount.to_s
end
