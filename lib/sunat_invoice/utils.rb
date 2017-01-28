module Utils
  def concat_xml(parent_str, child_str, key)
    i = parent_str.index("/#{key}>") + key.to_s.length + 1
    parent_str.insert(i, child_str)
  end

  def ubl_ext(hash)
    {
      "ext:UBLExtensions" => {
        "ext:UBLExtension" => {
          "ext:ExtensionContent" => hash
        }
      }
    }
  end

  def igv_tax(igv_amount)
    main_xml = Gyoku.xml(igv_amount, 1000, 'IGV', 'VAT')
    child_xml = Gyoku.xml("cbc:TaxExemptionReasonCode" => '10') # ?
    concat_xml(main_xml, child_xml, 'cac:TaxCategory')
  end

  def tax_scheme(amount, exemption_reason, id, name, tax_type)
    {
      "cac:TaxTotal" => {
        "cbc:TaxAmount" => amount,
        "cac:TaxSubtotal" => {
          "cbc:TaxAmount" => amount,
          "cac:TaxCategory" => {
            "cac:TaxScheme" => {
              "cbc:ID" => id,
              "cbc:Name" => name,
              "cbc:TaxTypeCode" => tax_type_code
            },
          },
        },
      },
    }
  end

  def isc_tax(isc_amount)
    main_xml = Gyoku.xml(tag_scheme(isc_amount, 2000, 'ISC', 'EXC'))
    child_xml = Gyoku.xml({'cbc:TierRange' => '02' })
    concat_xml(main_xml, child_xml, 'cac:TaxCategory')
  end

  def other_tax
    {
      "cac:TaxTotal" => {
        "cbc:TaxAmount" => :other_tax_amount,
        "cac:TaxSubtotal" => {
          "cbc:TaxAmount" => :other_tax_amount,
          "cac:TaxCategory" => {
            "cac:TaxScheme" => {
              "cbc:ID" => 9999,
              "cbc:Name" => "OTROS",
              "cbc:TaxTypeCode" => "OTH"
            },
          },
        },
      }
    }
  end

  def total_tax(venta_gravada, venta_inafecta, venta_exonerada, venta_gratuita)
    payable_xml(venta_gravada, 1001) + payable_xml(venta_inafecta, 1002) +
    payable_xml(venta_exonerada, 1003) + payable_xml(venta_gratuita, 1004)
  end

  private

  def payable_xml(amount, code)
    Gyoku.xml("sac:AdditionalMonetaryTotal" => {
      "cbc:ID" => code,
      "cbc:PayableAmount" => amount
    })
  end
end
