# frozen_string_literal: false

require_relative 'daily_summary'

module SunatInvoice
  class Voided < DailySummary
    private

    def namespaces
      VOIDED_NAMESPACES.merge(SUMMARY_NAMESPACES)
    end

    def root_name
      'VoidedDocuments'
    end

    def document_number
      formatted = date.strftime('%Y%m%d') #  YYYYMMDD
      "RA-#{formatted}-1"
    end
  end
end
