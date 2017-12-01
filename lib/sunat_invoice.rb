# frozen_string_literal: true

require 'sunat_invoice/invoice'
require 'sunat_invoice/provider'
require 'sunat_invoice/customer'
require 'sunat_invoice/item'
require 'sunat_invoice/tax'
require 'sunat_invoice/client'

module SunatInvoice
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :account_ruc, :account_user, :account_password,
                  :signature_path
  end
end
