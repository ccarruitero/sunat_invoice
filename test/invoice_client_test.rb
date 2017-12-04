# frozen_string_literal: true

require_relative 'helper'

scope 'SunatInvoice::InvoiceClient' do
  setup do
    provider = FactoryBot.build(:provider,
                                signature_id: 'signatureST',
                                signature_location_id: 'signQWI3',
                                ruc: '20100454523',
                                name: 'SOPORTE TECNOLOGICO EIRL')

    customer = FactoryBot.build(:customer,
                                ruc: '20293028401',
                                name: 'SOME BUSINESS')
    SunatInvoice.configure do |c|
      c.account_ruc = provider.ruc
      c.account_user = 'MODDATOS'
      c.account_password = 'moddatos'
      c.provider = provider
    end
    @client = SunatInvoice::InvoiceClient.new

    tax = SunatInvoice::Tax.new(amount: 3.6, tax_type: :igv)
    item = FactoryBot.build(:item, taxes: [tax])
    @invoice = SunatInvoice::Invoice.new(provider: provider,
                                         customer: customer,
                                         document_number: 'FY02-234')
    @invoice.items << item
  end

  test 'should use dev service when not define environment' do
    assert_equal @client.wsdl, @client.dev_server
  end

  test '#send_invoice success' do
    response = @client.send_invoice(@invoice.xml, @invoice.document_name)
    assert_equal response.http.code, 200
  end
end
