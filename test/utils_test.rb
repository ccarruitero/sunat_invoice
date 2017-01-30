require_relative 'helper'
require_relative '../lib/sunat_invoice/utils'
include Utils

scope do
  test 'concat_xml can insert xml inside other xml' do
    hash = ubl_ext(nana: 'nasf')
    inner_xml = Gyoku.xml(hash)
    other_hash = { 'Invoice' => { name: 'soemname' } }
    parent_xml = Gyoku.xml(other_hash)
    final_xml = concat_xml(parent_xml, inner_xml, 'name')
    assert final_xml.include?('ext:UBLExtensions')
    # binding.pry
    # Nokogiri::XML(final_xml)
    # need an xml parser that allow insert new content
  end

  test 'total_tax' do
    xml = total_tax(200, 0, 0, 0)
    assert xml.include?('sac:AdditionalMonetaryTotal')
    # TODO: count matchs
  end
end
