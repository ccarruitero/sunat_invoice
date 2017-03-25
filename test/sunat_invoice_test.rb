# frozen_string_literal: true
require_relative 'helper'
include SunatInvoice

scope 'SunatInvoice' do
  test 'should set dev api_server when initialize without option' do
    # gem is not broken
    client = SunatInvoice::Client.new
    api_server = client.instance_variable_get(:@bill_service_path)
    assert api_server == 'https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService?wsdl'
  end
end
