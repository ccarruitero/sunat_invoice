# frozen_string_literal: true

require_relative 'model'

module SunatInvoice
  class Tributer < Model
    attr_accessor :ruc, :name, :document_type, :ubigeo, :street, :zone,
                  :province, :department, :district, :country_code
  end
end
