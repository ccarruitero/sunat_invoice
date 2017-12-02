# frozen_string_literal: true

require 'sunat_invoice/invoice'
require 'sunat_invoice/provider'
require 'sunat_invoice/customer'
require 'sunat_invoice/item'
require 'sunat_invoice/tax'
require 'sunat_invoice/configuration'
require 'sunat_invoice/client'
require 'sunat_invoice/clients/invoice_client'

module SunatInvoice
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
