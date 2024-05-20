CLASS zcl_etr_export_process DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS: create_filen_orders IMPORTING iv_document_no TYPE zetr_e_filen
                                                 iv_vbeln       TYPE zetr_e_vbeln .