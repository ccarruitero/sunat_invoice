# frozen_string_literal: false

FactoryBot.define do
  factory :tax, class: 'SunatInvoice::Tax' do
    amount 20
    tax_type :igv
  end

  factory :item, class: 'SunatInvoice::Item' do
    quantity 10
    unit_code 'NIU'
    price 20
    price_code '01'
    description 'Grabadora Externo'
  end

  factory :invoice, class: 'SunatInvoice::Invoice' do
    provider { build(:provider) }
    customer { build(:customer) }

    initialize_with { new(attributes) }
  end

  factory :daily_summary, class: 'SunatInvoice::DailySummary' do
    provider { build(:provider) }
    signature { build(:signature, provider: provider) }
  end

  factory :provider, class: 'SunatInvoice::Provider' do
    pk_file File.join(File.dirname(__FILE__), 'certs/pk_file')
    cert_file File.join(File.dirname(__FILE__), 'certs/cert_file')
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

    initialize_with { new(attributes) }
  end

  factory :customer, class: 'SunatInvoice::Customer' do
    ruc FFaker::IdentificationMX.curp
    name FFaker::Company.name
    document_type 6

    initialize_with { new(attributes) }
  end

  factory :signature, class: 'SunatInvoice::Signature' do
    provider { build(:provider) }
  end
end
