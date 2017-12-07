# frozen_string_literal: true

# documents
require 'sunat_invoice/xml_document'
require 'sunat_invoice/invoice'
require 'sunat_invoice/provider'
require 'sunat_invoice/customer'
require 'sunat_invoice/item'
require 'sunat_invoice/tax'
require 'sunat_invoice/daily_summary'
require 'sunat_invoice/summary_line'
require 'sunat_invoice/credit_note'
require 'sunat_invoice/credit_note_line'
require 'sunat_invoice/debit_note'
require 'sunat_invoice/debit_note_line'

# clients
require 'sunat_invoice/configuration'
require 'sunat_invoice/response_parser'
require 'sunat_invoice/client'
require 'sunat_invoice/clients/invoice_client'
require 'sunat_invoice/clients/consult_client'

module SunatInvoice
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
