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
end
