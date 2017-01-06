require_relative 'ubl_tags'

module SunatInvoice
  class Invoice

    BASIC_FIELDS = []

    def initialize
      # @signature_path = config.signature_path
      # @signature_id = 
      @fields = []
      get_fields @fields, TAGS_UBL
      # @fields.each { |field| set_field_value(field) }
    end

    def get_fields array, hash, prefix=nil
      hash.each do |key, value|
        key_s = key.to_s
        if value.is_a? Hash
          get_fields(array, value, key_s)
        else
          array << (prefix.nil? ? key_s : "#{prefix}_#{key_s}")
        end
      end
    end

    def set_field_value fields
      fields.each do |key, value|
        if value.class == Hash
          value.each do |k, v|
            instance_variable_set("@#{key.to_s}_#{k.to_s}_value", v)
          end
        else
          instance_variable_set("@#{key.to_s}_value", value)
        end
      end
    end

    def get_field_value field
      return unless field.class == Array
      if field.length > 1
        composed_field = ""
        field.each {|f| composed_field += "_#{f.to_s}" }
        composed_field = composed_field.sub("_", "")
        instance_variable_get("@#{composed_field}_value")
      else
        instance_variable_get("@#{field[0].to_s}_value")
      end
    end

    def get_tag args
      # args is an array of symbols
      tag = TAGS_UBL
      for i in args do
        tag = tag[i]
      end
      tag
    end

    def get_hash_xml hash, field
      tag = get_tag(field)
      tag_value = get_field_value(field)
      hash.merge!(:"#{tag}"=> tag_value)
    end

    def get_xml
      hash = {}
      @fields.each { |field| get_hash_xml(hash, field) }

      gyoku_xml = Gyoku.xml(invoice: hash)
      Nokogiri.XML(gyoku_xml).to_xml
    end

    def provider_xml provider
      Gyoku.xml("cac:Signature" => {
        "cbc:ID" => "",
        "cac:SignatoryParty" => {
          "cac:PartyIdentification" => {
            "cbc:ID" => provider.id
          },
          "cac:PartyName" => {
            "cbc:Name" => provider.name
          }
        },
        "cac:DigitalSignatureAttachment" => {
          "cac:ExternalReference" => {
            "cbc:URI" => ""
          }
        }
      })
    end

    def supplier_xml supplier
      Gyoku.xml("cac:AccountingSupplierParty" => {
        "cbc:CustomerAssignedAccountID" => supplier.ruc,
        "cbc:AdditionalAccountID" => "",
        "cac:Party" => {
          "cac:PartyName" => {
            "cbc:Name" => supplier.name
          },
          "cac:PostalAddress": ""
        }
      })
    end
  end
end
