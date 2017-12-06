# frozen_string_literal: true

require_relative 'helper'

scope 'SunatInvoice::ResponseParser' do
  test 'invoice success response' do
    response_xml = ResponseHelper.load('invoice_success.xml')
    parser = ResponseHelper.parser
    hash = parser.parse(response_xml)
    envelope = parser.find(hash, 'Envelope')
    body = parser.find(envelope, 'Body')
    response = SunatInvoice::ResponseParser.new(body, 'invoice')

    assert_equal response.status_code, '0'
    assert response.message.include?('aceptada')
  end
end
