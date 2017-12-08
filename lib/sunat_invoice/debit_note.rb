# frozen_string_literal: false

require_relative 'credit_note'

module SunatInvoice
  class DebitNote < CreditNote
    # * date - issued date
    # * ref_document_number - serial and number of document affected
    # * ref_document_type - type of document affected
    # * response_code - reason for which debit note is issued (CATALOG_10)
    # * description - description of reason
    # * document_type - should be '08' according CATALOG_01
    # * document_number - serial and correlative number of document
    # * provider - a SunatInvoice::Provider instance
    # * customer - a SunatInvoice::Customer instance
    # * signature - a SunatInvoice::Signature instance
    # * lines - array of SunatInvoice::DebitNoteLine instances

    private

    def root_name
      'DebitNote'
    end

    def namespaces
      DEBIT_NOTE_NAMESPACES.merge(TRADE_NAMESPACES)
    end

    def total_tag
      'RequestedMonetaryTotal'
    end
  end
end
