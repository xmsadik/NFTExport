  METHOD call_pdf.
    DATA lv_button TYPE c.
    DATA: lo_badi TYPE REF TO zetr_if_exp_prn.

    IF lo_badi IS BOUND.
      lo_badi->get_pdf( EXPORTING iv_billingdocument = iv_billingdocument
                                  iv_button          = lv_button
                                  iv_fileexportno    = iv_export_no
                                  iv_dummy           = ''
                        IMPORTING ev_document_value = ev_pdf  ).
    ENDIF.

  ENDMETHOD.