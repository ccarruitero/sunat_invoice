# frozen_string_literal: true

module SunatInvoice
  class Model
    def initialize(options = {})
      options.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    def to_hash
      hash = {}
      instance_variables.map do |var|
        var_name = var.to_s.split('@')[1]
        hash[var_name] = instance_variable_get(var)
      end
      hash
    end
  end
end
