# frozen_string_literal: true

require_relative 'helper'

scope 'SunatInvoice::ResponseParser' do
  test 'invoice success response' do
    response_xml = ResponseHelper.load('invoice_success.xml')
    body = ResponseHelper.parse(response_xml)
    response = SunatInvoice::ResponseParser.new(body, 'invoice')

    assert_equal response.status_code, '0'
    assert response.message.include?('aceptada')
  end

  test 'summary success response' do
    response_xml = ResponseHelper.load('summary_success.xml')
    body = ResponseHelper.parse(response_xml)
    response = SunatInvoice::ResponseParser.new(body, 'summary')
    assert response.ticket.length.positive?
  end

  test 'get_status response' do
    response_xml = ResponseHelper.load('ticket_invalid.xml')
    body = ResponseHelper.parse(response_xml)
    response = SunatInvoice::ResponseParser.new(body, 'status')
    assert_equal response.message, 'El ticket no existe'
  end
end
