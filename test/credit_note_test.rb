# frozen_string_literal: false

require_relative 'helper'

setup do
  provider = FactoryBot.build(:provider)
  signature = FactoryBot.build(:signature, provider: provider)
  note = FactoryBot.build(:credit_note, provider: provider,
                                        signature: signature)
  @parsed_xml = Nokogiri::XML(note.xml, &:noblanks)
end

test 'start with CreditNote tag' do
  puts @parsed_xml
  assert_equal @parsed_xml.root.name, 'CreditNote'
end
