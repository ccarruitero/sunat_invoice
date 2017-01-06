# UBL  2.0 firma electrónica XMLDSIG1

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
