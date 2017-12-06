# frozen_string_literal: true

require_relative 'model'
require_relative 'utils'

module SunatInvoice
  class SummaryLine < Model
    include Utils

    attr_accessor :document_type, :document_serial, :start_document_number,
                  :end_document_number, :total_amount, :taxes, :taxable,
                  :non_taxable, :exempt, :other_charge, :charge_type

    CHARGES = {
      discount: false,
      charge: true
    }.freeze

    def initialize(*args)
      super(*args)
      @taxable ||= 0
      @non_taxable ||= 0
      @exempt ||= 0
      @other_charge ||= 0
    end

    def xml(xml, index, currency)
      xml['sac'].SummaryDocumentsLine do
        xml['cbc'].LineID(index + 1)
        build_documents_info(xml)
        amount_xml(xml['sac'], 'TotalAmount', total_amount, currency)
        build_payments(xml, currency)
        build_other_charge(xml, currency)
        build_taxes_xml(xml, currency)
      end
    end

    private

    def payments
      [{ amount: taxable, code: '01' },
       { amount: exempt, code: '02' },
       { amount: non_taxable, code: '03' }]
    end

    def build_documents_info(xml)
      xml['cbc'].DocumentTypeCode document_type
      xml['sac'].DocumentSerialID document_serial
      xml['sac'].StartDocumentNumberID start_document_number
      xml['sac'].EndDocumentNumberID end_document_number
    end

    def calculate_total_amount
      return if total_amount
      # TODO: sum(billing payments) + allowance charge + sum(taxes)
    end

    def build_payments(xml, currency)
      payments.each do |payment|
        xml['sac'].BillingPayment do
          amount_xml(xml['cbc'], 'PaidAmount', payment[:amount], currency)
          xml['cbc'].InstructionID payment[:code]
        end
      end
    end

    def build_other_charge(xml, currency)
      xml['cac'].AllowanceCharge do
        xml['cbc'].ChargeIndicator resolve_charge_type
        amount_xml(xml['cbc'], 'Amount', other_charge, currency)
      end
    end

    def resolve_charge_type
      charge_type ? CHARGES[charge_type] : CHARGES.values.first
    end

    def build_taxes_xml(xml, currency)
      taxes&.each do |tax|
        tax.xml(xml, currency)
      end
    end
  end
end
