# frozen_string_literal: false

module SunatInvoice
  module Catalogs
    # SUNAT codes

    # Tipo de documento
    CATALOG_01 = [
      '01', # FACTURA
      '03', # BOLETA DE VENTA
      '06', # CARTA DE PORTE AÉREO
      '07', # NOTA DE CREDITO
      '08', # NOTA DE DEBITO
      '09', # GUIA DE REMISIÓN REMITENTE
      '12', # TICKET DE MAQUINA REGISTRADORA
      '13', # DOCUMENTO EMITIDO POR BANCOS, INSTITUCIONES FINANCIERAS
      '14', # RECIBO DE SERVICIOS PÚBLICOS
      '15',
      # BOLETOS EMITIDOS POR SERVICIO TRANSPORTE PÚBLICO TERRESTRE REGULAR
      # URBANO DE PASAJEROS Y FERROVIARIO PÚBLICO DE PASAJEROS
      '16',
      # BOLETOS EMITIDOS POR SERVICIO TRANSPORTE PÚBLICO TERRESTRE
      # INTERPROVINCIAL DE PASAJEROS
      '18', # DOCUMENTOS EMITIDOS POR LAS AFP
      '20', # COMPROBANTE DE RETENCIÓN
      '21',
      # CONOCIMIENTO DE EMBARQUE POR EL SERVICIO DE TRANSPORTE DE CARGA MARÍTIMA
      '24', # CERTIFICADO DE PAGO DE REGALÍAS EMITIDAS POR PERUPETRO S.A.
      '31', # GUIA DE REMISIÓN TRANSPORTISTA
      '37',
      # DOCUMENTOS EMITIDOS POR CONCESIONARIOS DE SERVICIO DE REVISIONES
      # TÉCNICAS
      '40', # COMPRANTE DE PERCEPCIÓN
      '43', # BOLETO DE COMPAÑIAS DE AVIACIÓN TRANSPORTE AÉREO NO REGULAR
      '45',
      # DOCUMENTOS EMITIDOS POR CENTROS EDUCATIVOS Y CULTURALES, UNIVERSIDADES,
      # ASOCIACIONES Y FUNDACIONES
      '56', # COMPROBANTE DE PAGO SEAE
      '71', # GUIA DE REMISIÓN REMITENTE COMPLEMENTARIA
      '72'  # GUIA DE REMISIÓN TRANSPORTISTA COMPLEMENTARIA

    ].freeze

    # Tipo de Tributo
    CATALOG_05 = [
      '1000', # IGV
      '1016', # IVAP
      '2000', # ISC
      '9995', # EXP - EXPORTACION
      '9996', # GRA - GRATUITO
      '9997', # EXO - EXONERADO
      '9998', # INA - INAFECTO
      '9999'  # OTROS
    ].freeze

    # Tipo de Documentos de Identidad
    CATALOG_06 = [
      '0', # DOC.TRIB.NO.DOM.SIN.RUC
      '1', # DOC. NACIONAL DE IDENTIDAD
      '4', # CARNET DE EXTRANJERIA
      '6', # REG. UNICO DE CONTRIBUYENTES
      '7', # PASAPORTE
      'A', # CED. DIPLOMATICA DE IDENTIDAD
      'B', # DOCUMENTO IDENTIDAD PAIS RESIDENCIA - NO DOMICILIADO
      'C', # TAX IDENTIFICATION NUMBER - TIN – DOC TRIB PP.NN
      'D', # IDENTIFICATION NUMBER - IN – DOC TRIB PP.JJ
      'E'  # TARJETA ANDINA DE MIGRACION - TAM
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
      '17', # Gravado –IVAP
      '20', # Exonerado - Operación Onerosa
      '21', # Exonerado - Transferencia Gratuita
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
      '03'  # Sistema de Precios de Venta al Público
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
      '09', # Disminución en el valor
      '10', # Otros Conceptos
      '11', # Ajustes de operaciones de exportación
      '12'  # Ajustes afectos al IVAP
    ].freeze

    # Tipo de Nota de Débito Electrónica
    CATALOG_10 = [
      '01', # Intereses por mora
      '02', # Aumento en el valor
      '03', # Penalidades/ otros conceptos
      '10', # Ajustes de operaciones de exportación
      '11'  # Ajustes afectos al IVAP
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
      '02', # Factura – emitida por anticipos
      '03', # Boleta de Venta – emitida por anticipos
      '04', # Ticket de Salida - ENAPU
      '05', # Código SCOP
      '99'  # Otros
    ].freeze

    # Otros conceptos tributarios
    CATALOG_14 = [
      '1000', # Total valor de venta –operaciones exportadas
      '1001', # Total valor de venta - operaciones gravadas
      '1002', # Total valor de venta - operaciones inafectas
      '1003', # Total valor de venta - operaciones exoneradas
      '1004', # Total valor de venta - Operaciones gratuitas
      '1005', # Sub total de venta
      '2001', # Percepciones
      '2002', # Retenciones
      '2003', # Detracciones
      '2004', # Bonificaciones
      '2005', # Total descuentos
      '3001'  # FISE (Ley 29852) Fondo Inclusión Social Energético
    ].freeze

    # Elementos adicionales en la Factura y/o Boleta de Venta Electrónica
    CATALOG_15 = [
      '1000', # Monto en Letras
      '1002',
      # Leyenda “TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO
      # GRATUITAMENTE”
      '2000', # Leyenda “COMPROBANTE DE PERCEPCIÓN”
      '2001',
      # Leyenda “BIENES TRANSFERIDOS EN LA AMAZONÍA REGIÓN SELVA PARA SER
      # CONSUMIDOS EN LA MISMA”
      '2002',
      # Leyenda “SERVICIOS PRESTADOS EN LA AMAZONÍA REGIÓN SELVA PARA SER
      # CONSUMIDOS EN LA MISMA”
      '2003',
      # Leyenda “CONTRATOS DE CONSTRUCCIÓN EJECUTADOS EN LA AMAZONÍA REGIÓN
      # SELVA”
      '2004', # Leyenda “Agencia de Viaje - Paquete turístico”
      '2005', # Leyenda “Venta realizada por emisor itinerante”
      '2006', # Leyenda: Operación sujeta a detracción
      '2007', # Leyenda: Operación sujeta a IVAP
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
      '4009',
      # Beneficio Hospedajes: Paquete turístico – Numero de documento identidad
      # de huésped
      '5000', # Proveedores Estado: Número de Expediente
      '5001', # Proveedores Estado : Código de unidad ejecutora
      '5002', # Proveedores Estado : N° de proceso de selección
      '5003', # Proveedores Estado : N° de contrato
      '6000', # Comercialización de Oro :  Código Unico Concesión Minera
      '6001', # Comercialización de Oro :  N° declaración compromiso
      '6002', # Comercialización de Oro :  N° Reg. Especial .Comerci. Oro
      '6003',
      # Comercialización de Oro :  N° Resolución que autoriza Planta de
      # Beneficio
      '6004', # Comercialización de Oro : Ley Mineral (% concent. oro)
      '7000',
      # Primera venta de mercancía identificable entre usuarios de la zona
      # comercial
      '7001'
      # Venta exonerada del IGV-ISC-IPM. Prohibida la venta fuera de la zona
      # comercial de Tacna
    ].freeze

    # Tipo de Precio de Venta Unitario
    CATALOG_16 = [
      '01', # Precio unitario (incluye el IGV)
      '02'  # Valor referencial unitario en operaciones no onerosas
    ].freeze

    # Tipo de Operación
    CATALOG_17 = [
      '01', # Venta Interna
      '02', # Exportación de bienes
      '03', # No Domiciliados
      '04', # Venta Interna – Anticipos
      '05', # Venta Itinerante
      '06', # Factura Guía
      '07', # Venta Arroz Pilado
      '08', # Factura - Comprobante de Percepción
      '10', # Factura - Guía remitente
      '11', # Factura - Guía transportista
      '12', # Boleta de venta – Comprobante de Percepción
      '13', # Gasto Deducible Persona Natural
      '14',
      # Exportación de servicios – Prestación de servicios de hospedaje No Dom
      '15', # Exportación de servicios – Transporte de navieras
      '16',
      # Exportación de servicios – Servicios a naves y aeronaves de bandera
      # extranjera
      '17', # Exportación de servicios – RES
      '18',
      # Exportación de servicios - Servicios que conformen un Paquete Turístico
      '19',
      # Exportación de servicios – Servicios complementarios al transporte de
      # carga
      '20',
      # Exportación de servicios – Suministro de energía eléctrica a favor de
      # sujetos domiciliados en ZED
      '21'
      # Exportación de servicios – Prestación servicios realizados parcialmente
      # en el extranjero
    ].freeze

    # Modalidad de traslado
    CATALOG_18 = [
      '01', # Transporte público
      '02'  # Transporte privado
    ].freeze

    # Resumen diario de boletas de venta y notas electrónicas
    # Códigos de estado de ítem
    CATALOG_19 = [
      '1', # Adicionar
      '2', # Modificar
      '3'  # Anulado
    ].freeze

    # Motivos de traslado
    CATALOG_20 = [
      '01', # Venta
      '14', # Venta sujeta a confirmación del comprador
      '02', # Compra
      '04', # Traslado entre establecimientos de la misma empresa
      '08', # Importación
      '09', # Exportación
      '18', # Traslado emisor itinerante CP
      '19', # Traslado a zona primaria
      '13'  # Otros
    ].freeze

    # Documentos relacionados-aplicable solo para Guía de remisión electrónica
    CATALOG_21 = [
      '01', # Numeración DAM
      '02', # Número de orden de entrega
      '03', # Número SCOP
      '04', # Número de manifiesto de carga
      '05', # Número de constancia de detracción
      '06'  # Otros
    ].freeze
  end
end
