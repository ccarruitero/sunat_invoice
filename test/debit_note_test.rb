# frozen_string_literal: false

require_relative 'helper'

setup do
  provider = FactoryBot.build(:provider)
  signature = FactoryBot.build(:signature, provider: provider)
  note = FactoryBot.build(:debit_note, provider: provider,
                                       signature: signature)
  @parsed_xml = Nokogiri::XML(note.xml, &:noblanks)
end

test 'start with DebitNote tag' do
  assert_equal @parsed_xml.root.name, 'DebitNote'
end
