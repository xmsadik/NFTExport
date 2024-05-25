  METHOD call_pdf.

    DATA: lo_badi  TYPE REF TO zetr_if_exp_prn.    " BAdI arayüz tipi
    DATA lv_button TYPE c.

    lv_button = iv_button_id.

    TRY.
        DATA(lo_instance)  = zetr_export=>get_instance(  ).
        lo_badi ?= lo_instance.
      CATCH cx_abap_context_info_error.
    ENDTRY.

    IF lo_badi IS BOUND.
      CALL METHOD lo_badi->get_pdf
        EXPORTING
          iv_billingdocument = iv_billingdocument
          iv_button          = lv_button
          iv_fileexportno    = iv_export_no
          iv_dummy           = ''
        IMPORTING
          ev_document_value  = ev_pdf.
    ENDIF.

  ENDMETHOD.