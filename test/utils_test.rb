# frozen_string_literal: false
require_relative 'helper'
require_relative '../lib/sunat_invoice/utils'
include Utils

def setup_namespaces(child_xml)
  build = Nokogiri::XML::Builder.new do |xml|
    xml.root(UBL_NAMESPACES) { xml << child_xml }
  end
  @parsed_xml = Nokogiri::XML(build.to_xml, &:noblanks)
end

scope 'igv_tax' do
  setup do
    setup_namespaces(igv_tax(20))
  end

  test 'has correct root tag' do
    assert_equal @parsed_xml.root.children.count, 1
    assert_equal @parsed_xml.root.children.first.name, 'TaxTotal'
    assert_equal @parsed_xml.root.children.first.namespace.prefix, 'cac'
  end

  test 'has amount in correct tag' do
    tag_path = '//cac:TaxTotal/cbc:TaxAmount'
    amount = @parsed_xml.xpath(tag_path)
    assert_equal amount.count, 1
    assert_equal amount.first.content, '20'
    # cac:TaxTotal/cbc:TaxAmount/@currencyID
  end

  test 'has unique tag' do
    tag_path = '//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory'
    uniq_tag = @parsed_xml.xpath("#{tag_path}/cbc:TaxExemptionReasonCode")
    assert_equal uniq_tag.count, 1
    assert_equal uniq_tag.first.content, '10'
  end

  test 'has correct values in TaxScheme' do
    tag_path = '//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme'
    id = @parsed_xml.xpath("#{tag_path}/cbc:ID")
    assert_equal id.first.content, '1000'

    name = @parsed_xml.xpath("#{tag_path}/cbc:Name")
    assert_equal name.first.content, 'IGV'

    tax_code = @parsed_xml.xpath("#{tag_path}/cbc:TaxTypeCode")
    assert_equal tax_code.first.content, 'VAT'
  end
end

test 'total_tax' do
  xml = total_tax(200, 0, 0, 0)
  assert xml.include?('sac:AdditionalMonetaryTotal')
  # TODO: count matchs
end

# concat_xml

setup do
  @parent = Gyoku.xml(book: {
                        lorem: FFaker::Lorem.phrase,
                        dizzleipsum: {}
                      })
  @child = Gyoku.xml(food: FFaker::Food.fruit)
end

test 'concat_xml can concat 2 xmls' do
  hash = ubl_ext(nana: 'nasf')
  inner_xml = Gyoku.xml(hash)
  other_hash = { 'Invoice' => { name: FFaker::Name.name } }
  parent_xml = Gyoku.xml(other_hash)
  final_xml = concat_xml(parent_xml, inner_xml, 'name')
  assert final_xml.include?('ext:UBLExtensions')
end

test 'receive xml in string format' do
  main_xml = concat_xml(@parent, @child, 'dizzleipsum')
  assert main_xml
end

test 'return if not receive an string' do
  main_xml = concat_xml({}, 'asfs', 'zlas')
  assert main_xml.nil?
end

test 'can insert a xml inside a tag' do
  main_xml = Nokogiri::XML(concat_xml(@parent, @child, 'dizzleipsum', 'inside'))
  tag = main_xml.children.last.children.last
  assert tag.name == 'dizzleipsum'
  assert tag.children.to_s == @child
end

test 'can insert a xml before a tag' do
  main_xml = Nokogiri::XML(concat_xml(@parent, @child, 'dizzleipsum', 'before'))
  assert main_xml.children.first.children.first(2).last.name == 'food'
end

test 'can insert a xml after a tag' do
  main_xml = Nokogiri::XML(concat_xml(@parent, @child, 'dizzleipsum'))
  assert main_xml.children.first.children.last.name == 'food'
end
