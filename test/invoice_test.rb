# frozen_string_literal: false
require_relative 'helper'
include SunatInvoice

scope 'Invoice' do
  setup do
    @invoice = SunatInvoice::Invoice.new
  end

  # teardown do
  #   @invoice = nil
  # end

  test 'is not broken' do
    assert !@invoice.nil?
  end

  test 'has at least basic info' do
  end

  test 'xml start with invoice tag' do
    parsed_xml = Nokogiri::XML(@invoice.xml)
    invoice = parsed_xml.children.first

    # TODO: clean line jump
    assert invoice.name == 'invoice'

    date = invoice.children.first(2).last
    assert date.name == 'cbc:IssueDate'
    assert date.children.first.content == DateTime.now.strftime('%Y-%m-%d')
    # signature_path
  end
end
