# frozen_string_literal: false

require_relative 'credit_note'

module SunatInvoice
  class DebitNote < CreditNote
    # * ref_document_number
    # * ref_document_type
    # * response_code -
    # * description
    # * document_type
    # * document_number

    private

    def root_name
      'DebitNote'
    end

    def namespaces
      DEBIT_NOTE_NAMESPACES.merge(TRADE_NAMESPACES)
    end
  end
end
