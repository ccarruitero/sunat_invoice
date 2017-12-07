# frozen_string_literal: true

require_relative 'model'
require_relative 'utils'

module SunatInvoice
  class Line < Model
    include Utils

    attr_accessor :taxes

    def build_taxes_xml(xml, currency)
      taxes&.each do |tax|
        tax.xml(xml, currency)
      end
    end
  end
end
