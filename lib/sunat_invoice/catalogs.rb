# frozen_string_literal: false

module SunatInvoice
  module Catalogs
    # SUNAT codes

    # Tipo de documento
    CATALOG_01 = [
      '01', # FACTURA
      '03', # BOLETA DE VENTA
      '07', # NOTA DE CREDITO
      '08', # NOTA DE DEBITO
      '09', # GUIA DE REMISIÓN REMITENTE
      '12', # TICKET DE MAQUINA REGISTRADORA
      '13', # DOCUMENTO EMITIDO POR BANCOS, INSTITUCIONES FINANCIERAS
      '18', # DOCUMENTOS EMITIDOS POR LAS AFP
      '31', # GUIA DE REMISIÓN TRANSPORTISTA
    ].freeze

    # Tipo de Tributo
    CATALOG_05 = [
      '1000', # IGV
      '2000', # ISC
      '9999'  # Otros
    ].freeze

    # Tipo de Documentos de Identidad
    CATALOG_06 = [
      '0', # DOC.TRIB.NO.DOM.SIN.RUC
      '1', # DOC. NACIONAL DE IDENTIDAD
      '4', # CARNET DE EXTRANJERIA
      '6', # REG. UNICO DE CONTRIBUYENTES
      '7', # PASAPORTE
      'A'  # CED. DIPLOMATICA DE IDENTIDAD
    ].freeze

    # Tipo de Afectación del IGV
    CATALOG_07 = [
      '10', # Gravado - Operación Onerosa
      '11', # Gravado – Retiro por premio
      '12', # Gravado – Retiro por donación
      '13', # Gravado – Retiro
      '14', # Gravado – Retiro por publicidad
      '15', # Gravado – Bonificaciones
      '16', # Gravado – Retiro por entrega a trabajadores
      '20', # Exonerado - Operación Onerosa
      '30', # Inafecto - Operación Onerosa
      '31', # Inafecto – Retiro por Bonificación
      '32', # Inafecto – Retiro
      '33', # Inafecto – Retiro por Muestras Médicas
      '34', # Inafecto - Retiro por Convenio Colectivo
      '35', # Inafecto – Retiro por premio
      '36', # Inafecto - Retiro por publicidad
      '40'  # Exportación
    ].freeze

    # Tipo de Sistema de Cáclulo del ISC
    CATALOG_08 = [
      '01', # Sistema al valor
      '02', # Aplicación del Monto Fijo
      '03', # Sistema de Precios de Venta al Público
    ].freeze

    # Tipo de Nota de Crédito Electrónica
    CATALOG_09 = [
      '01', # Anulación de la operación
      '02', # Anulación por error en el RUC
      '03', # Corrección por error en la descripción
      '04', # Descuento global
      '05', # Descuento por ítem
      '06', # Devolución total
      '07', # Devolución por ítem
      '08', # Bonificación
      '09'  # Disminución en el valor
    ].freeze

    # Tipo de Nota de Débito Electrónica
    CATALOG_10 = [
      '01', # Intereses por mora
      '02'  # Aumento en el valor
    ].freeze

    # Resumen Diario de Boletas de Ventas Electrónicas y Notas Electrónicas
    # Tipo de Valor de Venta
    CATALOG_11 = [
      '01', # Gravado
      '02', # Exonerado
      '03', # Inafecto
      '04', # Exportación
      '05'  # Gratuitas
    ].freeze

    # Documentos Relacionados Tributarios
    CATALOG_12 = [
      '01', # Factura – emitida para corregir error en el RUC
      '04', # Ticket de Salida - ENAPU
      '05', # Código SCOP
      '99'  # Otros
    ].freeze

    # Otros conceptos tributarios
    CATALOG_14 = [
      '1001', # Total valor de venta - operaciones gravadas
      '1002', # Total valor de venta - operaciones inafectas
      '1003', # Total valor de venta - operaciones exoneradas
      '1004', # Total valor de venta - Operaciones gratuitas
      '1005', # Sub total de venta
      '2001', # Percepciones
      '2002', # Retenciones
      '2003', # Detracciones
      '2004', # Bonificaciones
      '2005'  # Total descuentos
    ].freeze

    # Elementos adicionales en la Factura y/o Boleta de Venta Electrónica
    CATALOG_15 = [
      '1000', # Monto en Letras
      '1002',
      # Leyenda “TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO
      # GRATUITAMENTE”
      '2000', # Leyenda “COMPROBANTE DE PERCEPCIÓN”
      '2001',
      # Leyenda “BIENES TRANSFERIDOS EN LA AMAZONÍA REGIÓN SELVAPARA SER
      # CONSUMIDOS EN LA MISMA”
      '2002',
      # Leyenda “SERVICIOS PRESTADOS EN LA AMAZONÍA REGIÓN SELVA PARA SER
      # CONSUMIDOS EN LA MISMA”
      '2003',
      # Leyenda “CONTRATOS DE CONSTRUCCIÓN EJECUTADOS EN LA AMAZONÍA REGIÓN
      # SELVA”
      '2004', # Leyenda “Agencia de Viaje - Paquete turístico”
      '3000', # Detracciones: CODIGO DE BB Y SS SUJETOS A DETRACCION
      '3001', # Detracciones: NUMERO DE CTA EN EL BN
      '3002',
      # Detracciones: Recursos Hidrobiológicos-Nombre y matrícula de la
      # embarcación
      '3003',
      # Detracciones: Recursos Hidrobiológicos-Tipo y cantidad de especie
      # vendida
      '3004', # Detracciones: Recursos Hidrobiológicos -Lugar de descarga
      '3005', # Detracciones: Recursos Hidrobiológicos -Fecha de descarga
      '3006',
      # Detracciones: Transporte Bienes vía terrestre – Numero Registro MTC
      '3007',
      # Detracciones: Transporte Bienes vía terrestre -configuración vehicular
      '3008', # Detracciones: Transporte Bienes vía terrestre – punto de origen
      '3009', # Detracciones: Transporte Bienes vía terrestre – punto destino
      '3010',
      # Detracciones: Transporte Bienes vía terrestre – valor referencial
      # preliminar
      '4000', # Beneficio hospedajes: Código País de emisión del pasaporte
      '4001',
      # Beneficio hospedajes: Código País de residencia del sujeto no
      # domiciliado
      '4002', # Beneficio Hospedajes: Fecha de ingreso al país
      '4003', # Beneficio Hospedajes: Fecha de ingreso al establecimiento
      '4004', # Beneficio Hospedajes: Fecha de salida del establecimiento
      '4005', # Beneficio Hospedajes: Número de días de permanencia
      '4006', # Beneficio Hospedajes: Fecha de consumo
      '4007',
      # Beneficio Hospedajes: Paquete turístico - Nombres y Apellidos del
      # Huésped
      '4008',
      # Beneficio Hospedajes: Paquete turístico – Tipo documento identidad del
      # huésped
      '4009'
      # Beneficio Hospedajes: Paquete turístico – Numero de documento identidad
      # de huésped
    ].freeze

    # Tipo de Precio de Venta Unitario
    CATALOG_16 = [
      '01', # Precio unitario (incluye el IGV)
      '02'  # Valor referencial unitario en operaciones no onerosas
    ].freeze
  end
end
