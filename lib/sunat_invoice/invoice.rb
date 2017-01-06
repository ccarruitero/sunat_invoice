module SunatInvoice
  class Invoice
    #  UBL  2.0 firma  electrónica XMLDSIG1

    FIELDS = ['date', 'signature', 'registration_name']
    BASIC_FIELDS = []

    TAGS_UBL = {
      date: "cbc:IssueDate",
      signature: {
        digital_signature: "ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/ds:Signature id='#{@signature_id}'",
        },
      provider: {
      },
      registration_name: "cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName",
      name: "cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name",
      address: {
        ubigeo: "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:ID ",
        street: "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName",
        urbanizacion: "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName",
        provincia: "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName",
        departamento: "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity",
        district: "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District",
        country_code: "cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode ",
      },
      ruc: {
        ruc_number: "cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID",
        document_type: "cac:AccountingSupplierParty/cbc:AdditionalAccountID",
      },
      document_type: "cbc:InvoiceTypeCode",
      document_number: "cbc:ID",
      customer: {
        document_number: "cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID",
        document_type: "cac:AccountingCustomerParty/cbc:AdditionalAccountID",
      },
      customer_registration_name: "cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName",
    }

    def initialize
      # @signature_path = config.signature_path
      # @signature_id = 
      # FIELDS.each { |field| set_field_value(field) }
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
      FIELDS.each { |field| get_hash_xml(hash, field) }

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
