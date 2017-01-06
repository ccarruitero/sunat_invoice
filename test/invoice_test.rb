require_relative 'helper'
include SunatInvoice

scope "Invoice" do
  setup do
    @invoice = SunatInvoice::Invoice.new
  end

  # teardown do
  #   @invoice = nil
  # end

  test "is not broken" do
    assert @invoice != nil
  end

  test "has at least basic info" do
  end

  test "return correct tag" do
    assert @invoice.get_tag([:date]) == "cbc:IssueDate"
    assert @invoice.get_tag([:customer, :document_type]) == "cac:AccountingCustomerParty/cbc:AdditionalAccountID"
  end

  test "set and get given values for a single or composed field" do
    today = DateTime.now
    @invoice.set_field_value(date: today)
    assert @invoice.get_field_value([:date]) == today

    @invoice.set_field_value(registration_name: 'blabla', address: { ubigeo: 1234 })
    assert @invoice.get_field_value([:registration_name]) == 'blabla'
    assert @invoice.get_field_value([:address, :ubigeo]) == 1234
  end

  test "get a hash with tag and value according desired field" do
    today = DateTime.now
    @invoice.set_field_value(date: today)
    h = @invoice.get_hash_xml({}, [:date])
    assert h.keys.length == 1
    assert h.keys[0].to_s == "cbc:IssueDate"
    assert h.values[0] == today
  end
end
