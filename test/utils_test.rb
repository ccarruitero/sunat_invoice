# frozen_string_literal: false
require_relative 'helper'
require_relative '../lib/sunat_invoice/utils'
include Utils

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

  # Nokogiri::XML(final_xml)
  # need an xml parser that allow insert new content
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
  assert main_xml.children.first(2).last.children.first.name == 'food'
end

test 'can insert a xml after a tag' do
  main_xml = Nokogiri::XML(concat_xml(@parent, @child, 'dizzleipsum'))
  assert main_xml.children.first.children.last.name == 'food'
end
