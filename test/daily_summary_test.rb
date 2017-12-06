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

test 'ChargeIndicator must not be empty when not charge_type' do
  assert @line.charge_type.nil?
  assert !@parsed_xml.at('//cbc:ChargeIndicator').content.empty?
end

test 'AllowanceCharge Amount is 0' do
  amount = @parsed_xml.at('//cac:AllowanceCharge/cbc:Amount').content
  assert_equal amount, '0.01'
end
