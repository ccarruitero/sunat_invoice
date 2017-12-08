# frozen_string_literal: true

require_relative 'helper'

scope 'SunatInvoice::InvoiceClient' do
  setup do
    @provider = FactoryBot.build(:provider,
                                 signature_id: 'signatureST',
                                 signature_location_id: 'signQWI3',
                                 ruc: '20100454523',
                                 name: 'SOPORTE TECNOLOGICO EIRL')

    @customer = FactoryBot.build(:customer,
                                 ruc: '20293028401',
                                 name: 'SOME BUSINESS')
    SunatInvoice.configure do |c|
      c.account_ruc = @provider.ruc
      c.account_user = 'MODDATOS'
      c.account_password = 'moddatos'
      c.provider = @provider
    end
    @client = SunatInvoice::InvoiceClient.new

    tax = SunatInvoice::Tax.new(amount: 3.6, tax_type: :igv)
    item = FactoryBot.build(:item, taxes: [tax])
    @invoice = SunatInvoice::Invoice.new(provider: @provider,
                                         customer: @customer,
                                         document_number: 'FY02-234')
    @invoice.lines << item
  end

  test 'should use dev service when not define environment' do
    assert_equal @client.wsdl, @client.dev_server
  end

  test 'send invoice success' do
    response = @client.dispatch(@invoice)
    assert_equal response.http.code, 200
  end

  test 'send credit note' do
    tax = SunatInvoice::Tax.new(amount: 3.6, tax_type: :igv)
    line = FactoryBot.build(:credit_note_line, taxes: [tax])
    signature = FactoryBot.build(:signature, provider: @provider)
    credit_note = FactoryBot.build(:credit_note, provider: @provider,
                                                 customer: @customer,
                                                 lines: [line],
                                                 signature: signature)
    response = @client.dispatch(credit_note)
    assert_equal response.http.code, 200
  end

  test 'send debit note' do
    tax = SunatInvoice::Tax.new(amount: 3.6, tax_type: :igv)
    line = FactoryBot.build(:debit_note_line, taxes: [tax])
    signature = FactoryBot.build(:signature, provider: @provider)
    debit_note = FactoryBot.build(:debit_note, provider: @provider,
                                               customer: @customer,
                                               lines: [line],
                                               signature: signature)
    response = @client.dispatch(debit_note)
    assert_equal response.http.code, 200
  end

  test 'send summary success' do
    line = FactoryBot.build(:summary_line)
    signature = FactoryBot.build(:signature, provider: @provider)
    summary = SunatInvoice::DailySummary.new(provider: @provider,
                                             signature: signature,
                                             reference_date: Date.today,
                                             currency: 'PEN',
                                             lines: [line])
    response = @client.dispatch(summary)
    assert_equal response.http.code, 200
  end

  test 'get status' do
    ticket = rand(10**15).to_s
    response = @client.get_status(ticket)
    assert_equal response.http.code, 200
  end
end
