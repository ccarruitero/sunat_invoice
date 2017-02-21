# frozen_string_literal: false
module Utils
  def regex_type(mode, key)
    case mode

    when 'after'
      "/#{key}"
    else
      key
    end
  end

  def _index(mode, key)
    case mode

    when 'after'
      key.to_s.length + 2
    when 'before'
      - 1
    when 'inside'
      key.to_s.length + 1
    end
  end

  def concat_xml(parent_str, child_str, key, type = nil)
    return unless parent_str.is_a?(String) && child_str.is_a?(String)
    mode = type || 'after'
    i = parent_str.index(regex_type(mode, key)) + _index(mode, key)

    parent_str.insert(i, child_str)
  end

  def ubl_ext(hash)
    {
      'ext:UBLExtensions' => {
        'ext:UBLExtension' => {
          'ext:ExtensionContent' => hash
        }
      }
    }
  end

  def tax_scheme(amount, id, name, tax_type)
    {
      'cac:TaxTotal' => {
        'cbc:TaxAmount' => amount,
        'cac:TaxSubtotal' => {
          'cbc:TaxAmount' => amount,
          'cac:TaxCategory' => {
            'cac:TaxScheme' => {
              'cbc:ID' => id,
              'cbc:Name' => name,
              'cbc:TaxTypeCode' => tax_type
            }
          }
        }
      }
    }
  end

  def igv_tax(igv_amount)
    main_xml = Gyoku.xml(igv_amount, 1000, 'IGV', 'VAT')
    child_xml = Gyoku.xml('cbc:TaxExemptionReasonCode' => '10') # ?
    concat_xml(main_xml, child_xml, 'cac:TaxCategory')
  end

  def isc_tax(isc_amount)
    main_xml = Gyoku.xml(tag_scheme(isc_amount, 2000, 'ISC', 'EXC'))
    child_xml = Gyoku.xml('cbc:TierRange' => '02')
    concat_xml(main_xml, child_xml, 'cac:TaxCategory')
  end

  def other_tax(other_amount)
    Gyoku.xml(other_amount, 9999, 'OTROS', 'OTH')
  end

  def total_tax(venta_gravada, venta_inafecta, venta_exonerada, venta_gratuita)
    str = ''
    str << payable_xml(venta_gravada, 1001)
    str << payable_xml(venta_inafecta, 1002)
    str << payable_xml(venta_exonerada, 1003)
    str << payable_xml(venta_gratuita, 1004)
  end

  private

  def payable_xml(amount, code)
    Gyoku.xml('sac:AdditionalMonetaryTotal' => {
                'cbc:ID' => code,
                'cbc:PayableAmount' => amount
              })
  end
end
