# frozen_string_literal: true

require 'nori'
require_relative 'helper'

scope 'SunatInvoice::ResponseParser' do
  test 'success response' do
    response_xml = File.read("#{Dir.pwd}/test/fixtures/responses/success.xml")
    parser = Nori.new(delete_namespace_attributes: true,
                      convert_tags_to: ->(tag) { tag.snakecase.to_sym },
                      strip_namespaces: true)
    hash = parser.parse(response_xml)
    envelope = parser.find(hash, 'Envelope')
    body = parser.find(envelope, 'Body')
    response = SunatInvoice::ResponseParser.new(body)

    assert_equal response.status_code, '0'
    assert response.message.include?('aceptada')
  end
end
