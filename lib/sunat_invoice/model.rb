# frozen_string_literal: true

module SunatInvoice
  class Model
    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end
  end
end
