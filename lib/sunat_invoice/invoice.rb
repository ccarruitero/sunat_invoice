require_relative 'ubl_tags'
require_relative 'utils'

module SunatInvoice
  class Invoice
    include Utils

    BASIC_FIELDS = []

    def initialize(provider = nil, customer = nil)
      # @signature_path = config.signature_path
      # @signature_id = 
      @fields = []
      # get_fields @fields, TAGS_UBL
      # @fields.each { |field| set_field_value(field) }
      @provider = provider
      @customer = customer
    end

    def get_fields(array, hash)
      hash_parse(hash) do |key, value, prefix|
        key_s = key.to_s
        array << (prefix.nil? ? key_s : "#{prefix}_#{key_s}")
      end
    end

    def set_field_value(hash)
      hash_parse(hash) do |key, value, prefix|
        field_str = prefix.nil? ? key.to_s : "#{prefix}_#{key.to_s}"
        instance_variable_set("@#{field_str}_value", value)
      end
    end

    def hash_parse(hash, prefix = nil, &block)
      hash.each do |key, value|
        if value.is_a? Hash
          hash_parse value, key, &block
        else
          block.call(key, value, prefix)
        end
      end
    end

    def get_field_value(field)
      return unless field.class == Array
      if field.length > 1
        composed_field = ''
        field.each {|f| composed_field += "_#{f}" }
        composed_field = composed_field.sub("_", "")
        instance_variable_get("@#{composed_field}_value")
      else
        instance_variable_get("@#{field[0].to_s}_value")
      end
    end

    def get_tag(args)
      # args is an array of symbols
      tag = TAGS_UBL
      for i in args do
        tag = tag[i]
      end
      tag
    end

    def get_hash_xml(hash, field)
      tag = get_tag(field)
      tag_value = get_field_value(field)
      hash.merge!("#{tag}": tag_value)
    end

    def xml
      #hash = {}
      #@fields.each { |field| get_hash_xml(hash, field) }

      main_xml = Gyoku.xml(invoice: xml_hash)
      concat_xml(main_xml, ubl_ext('sac:AdditionalInformation' => {
                                    # TODO: total taxs
                                   }),'cac:InvoiceLine')
      Nokogiri.XML(gyoku_xml).to_xml
    end

    def xml_hash
      {
        'cbc:IssueDate' => :date,
        # digital sign
        'cac:Signature' => {
          'cbc:ID' => @provider.signature,
          "cac:SignatoryParty" => {
            "cac:PartyIdentification" => {
              "cbc:ID" => @provider.ruc
            },
            "cac:PartyName" => {
              "cbc:Name" => @provider.name
            }
          },
          "cac:DigitalSignatureAttachment" => {
            "cac:ExternalReference" => {
              "cbc:URI" => ""
            }
          }
        },
        "cac:AccountingSupplierParty" => {
          "cbc:CustomerAssignedAccountID" => @provider.ruc,
          "cbc:AdditionalAccountID" => @provider.document_type,
          "cac:Party" => {
            "cac:PartyName" => {
              "cbc:Name" => @provider.name
            },
            "cac:PostalAddress" => {
              "cbc:ID" => @provider.ubigeo,
              "cbc:StreetName" => @provider.street,
              "cbc:CitySubdivisionName" => @provider.urbanizacion,
              "cbc:CityName" => @provider.provincia,
              "cbc:CountrySubentity" => @provider.departamento,
              "cbc:District" => @provider.district,
              "cac:Country" => {
                "cbc:IdentificationCode" => @provider.country_code,
              }
            }
          },
          "cac:PartyLegalEntity" => {
            "cbc:RegistrationName" => @provider.registration_name
          }
        },
        "cbc:InvoiceTypeCode" => :document_type,
        "cbc:ID" => :document_number,
        "cac:AccountingCustomerParty" => {
          "cbc:CustomerAssignedAccountID" => @customer.ruc,
          "cbc:AdditionalAccountID" => @customer.document_type,
          "cac:Party" => {
            "cac:PartyLegalEntity" => {
              "cbc:RegistrationName" => @customer.registration_name
            }
          }
        },
        "cac:InvoiceLine" => {
        },
        "cac:LegalMonetaryTotal" => {
          "cbc:ChargeTotalAmount" => :total_amount
        },
        # desc
        "ext:UBLExtensions" => {
        }
      }
    end

    def attributes
      {
      :attributes! => {
        "cbc:InvoicedQuantity" => { "@unitCode" => :unit},
        "cbc:PriceAmount" => { "@currencyID" => :currency }, # PEN
        "cbc:TaxAmount" => { "@currencyID" => :currency }, # PEN
        "cbc:PayableAmount" => { "@currencyID" => :currency }, # PEN
        "cbc:LineExtensionAmount" => { "@currencyID" => :currency }, # PEN
        "cbc:ChargeTotalAmount" => { "@currencyID" => :currency }, # PEN
      }
      }
    end
  end
end
