# frozen_string_literal: true

require 'cutest'
require 'pry'
require 'ffaker'
require 'factory_bot'
require_relative '../lib/sunat_invoice'
require_relative 'factories'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

SignatureHelper.generate_keys
