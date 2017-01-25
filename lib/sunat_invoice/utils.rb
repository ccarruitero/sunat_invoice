module Utils
  def ubl_ext hash
    {
      "ext:UBLExtensions" => {
        "ext:UBLExtension" => {
          "ext:ExtensionContent" => hash
        }
      }
    }
  end

  def igv_tax
    {
      "cac:TaxTotal" => {
        "cbc:TaxAmount" => :igv_amount,
        "cac:TaxSubtotal" => {
          "cbc:TaxAmount" => :igv_amount,
          "cac:TaxCategory" => {
            "cbc:TaxExemptionReasonCode" => 10, # ?
            "cac:TaxScheme" => {
              "cbc:ID" => 1000,
              "cbc:Name" => "IGV",
              "cbc:TaxTypeCode" => "VAT"
            },
          },
        },
      },
    }
  end

  def isc_tax
    {
      "cac:TaxTotal" => {
        "cbc:TaxAmount" => :isc_amount,
        "cac:TaxSubtotal" => {
          "cbc:TaxAmount" => :isc_amount,
          "cac:TaxCategory" => {
            "cbc:TierRange" => "02", # ?
            "cac:TaxScheme" => {
              "cbc:ID" => 2000,
              "cbc:Name" => "ISC",
              "cbc:TaxTypeCode" => "EXC"
            },
          },
        },
      },
    }
  end

  def total_tax
    {
      "sac:AdditionalMonetaryTotal" => {
        "cbc:ID" => 1001,
        "cbc:PayableAmount" => :total_valor_venta_gravadas
      },
      "sac:AdditionalMonetaryTotal" => {
        "cbc:ID" => 1002,
        "cbc:PayableAmount" => :total_Valor_venta_inafectas
      },
      "sac:AdditionalMonetaryTotal" => {
        "cbc:ID" => 1003,
        "cbc:PayableAmount" => :total_valor_venta_exoneradas
      },
      "sac:AdditionalMonetaryTotal" => {
        "cbc:ID" => 1004,
        "cbc:PayableAmount" => :total_valor_venta_gratuitas
      },
    }
  end
end
