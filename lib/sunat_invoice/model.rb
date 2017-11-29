# frozen_string_literal: true

module SunatInvoice
  class Model
    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end
