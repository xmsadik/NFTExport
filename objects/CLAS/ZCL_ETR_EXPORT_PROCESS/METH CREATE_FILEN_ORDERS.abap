  METHOD create_filen_orders.

    DATA: ls_invoice      TYPE zetr_t_r102,
          lt_invoice_item TYPE TABLE OF zetr_t_r103.

    IF iv_document_no IS INITIAL OR iv_vbeln IS INITIAL.
      EXIT.
    ENDIF.

    ls_invoice = VALUE zetr_t_r102( filen = iv_document_no
                                    vbeln = iv_vbeln ).

    SELECT billingdocument, billingdocumentitem
      FROM i_billingdocumentitembasic
     WHERE billingdocument EQ @iv_vbeln
      INTO TABLE @DATA(lt_document).

    IF lt_document[] IS NOT INITIAL.
      LOOP AT lt_document ASSIGNING FIELD-SYMBOL(<fs_document>).
        APPEND INITIAL LINE TO lt_invoice_item ASSIGNING FIELD-SYMBOL(<fs_invoice_item>).
        <fs_invoice_item>-filen = iv_document_no.
        <fs_invoice_item>-vbeln = <fs_document>-billingdocument.
        <fs_invoice_item>-posnr = <fs_document>-billingdocumentitem.
      ENDLOOP.
    ENDIF.

    IF ls_invoice IS NOT INITIAL.
      MODIFY zetr_t_r102 FROM @ls_invoice.
    ENDIF.

    IF lt_invoice_item IS NOT INITIAL.
      MODIFY zetr_t_r103 FROM TABLE @lt_invoice_item.
    ENDIF.

  ENDMETHOD.