# frozen_string_literal: false

require_relative 'item'

module SunatInvoice
  class CreditNoteLine < Item
    def line_tag_name
      'CreditNoteLine'
    end

    def quantity_tag_name
      'CreditedQuantity'
    end
  end
end
