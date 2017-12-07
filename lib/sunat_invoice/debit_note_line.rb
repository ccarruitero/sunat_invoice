# frozen_string_literal: false

require_relative 'item'

module SunatInvoice
  class DebitNoteLine < Item
    def line_tag_name
      'DebitNoteLine'
    end

    def quantity_tag_name
      'DebitedQuantity'
    end
  end
end
