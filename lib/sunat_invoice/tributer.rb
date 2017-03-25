# frozen_string_literal: true
module SunatInvoice
  class Tributer
    attr_accessor :ruc, :name, :document_type, :ubigeo, :street, :urbanizacion,
                  :provincia, :departamento, :district, :country_code,
                  :registration_name

    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end
