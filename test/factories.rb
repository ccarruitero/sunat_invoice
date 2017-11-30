# frozen_string_literal: false

FactoryBot.define do
  factory :tax, class: 'SunatInvoice::Tax' do
    amount 20
    tax_type :igv
  end

  factory :item, class: 'SunatInvoice::Item' do
    quantity 10
  end

  factory :invoice, class: 'SunatInvoice::Invoice' do
  end

  factory :provider, class: 'SunatInvoice::Provider' do
    signature FFaker::LoremCN.paragraph
    ruc FFaker::IdentificationMX.curp
    name FFaker::Company.name
    document_type 6
    ubigeo '14'
    street ''
    zone ''
    province ''
    department ''
    district ''
    country_code ''
  end

  factory :customer, class: 'SunatInvoice::Customer' do
    ruc FFaker::IdentificationMX.curp
    name FFaker::Company.name
    document_type 6
  end
end
