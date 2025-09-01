CLASS lhc_zetr_ddl_c_exp_invoice DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_c_exp_invoice RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zetr_ddl_c_exp_invoice RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zetr_ddl_c_exp_invoice.
    METHODS added FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_c_exp_invoice~added RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_c_exp_invoice IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD added.
    READ ENTITIES OF zetr_ddl_c_exp_invoice
       IN LOCAL MODE ENTITY zetr_ddl_c_exp_invoice
     ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(invoices).



    DATA lv_export_no TYPE zetr_e_filen.

    TYPES: BEGIN OF tys_invoices,
             billingdocument TYPE i_billingdocument-billingdocument,
           END OF tys_invoices.
    DATA: lt_invoices TYPE STANDARD TABLE OF tys_invoices,
          ls_invoice  TYPE tys_invoices.

    DATA(lt_split)    = VALUE string_table( ).
    DATA(invoice_key) = VALUE #( keys[ 1 ] OPTIONAL ).

    IF invoice_key-%param IS NOT INITIAL.
      DATA(lv_invoice_keys) = invoice_key-%param-content.
      lv_export_no = CONV zetr_e_filen( invoice_key-%param-document  ).

      SPLIT lv_invoice_keys AT ';' INTO TABLE lt_split.

      LOOP AT lt_split INTO DATA(lv_value).
        ls_invoice-billingdocument = |{ lv_value ALPHA = IN }| .
        APPEND ls_invoice TO lt_invoices.
      ENDLOOP.


      SELECT billingdocument, customerpaymentterms,
             incotermsclassification, incotermstransferlocation,
             transactioncurrency
        FROM i_billingdocument
     FOR ALL ENTRIES IN @lt_invoices
       WHERE billingdocument = @lt_invoices-billingdocument
        INTO TABLE @DATA(lt_billingdocument).


      SELECT salesdocument,referencesddocument, shippingtype
        FROM i_salesdocument
     FOR ALL ENTRIES IN @lt_invoices
       WHERE referencesddocument = @lt_invoices-billingdocument
        INTO TABLE @DATA(lt_salesdocument).

    ELSE.
      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
                                          number   = '000'
                                          severity = if_abap_behv_message=>severity-error
                                          v1       = 'Lütfen belge numarası giriniz.' ) ) TO reported-zetr_ddl_c_exp_invoice.

      RETURN.
    ENDIF.

    zcl_etr_export_process=>create_filen_orders( iv_document_no = invoice_key-%param-document
                                                 iv_vbeln       = ''
                                                 it_vbeln       = lt_invoices ).

    IF lt_salesdocument[] IS NOT INITIAL.
      READ TABLE lt_salesdocument INTO DATA(ls_sales) INDEX 1.
    ENDIF.

    " BillingDocument verileri
    IF lt_billingdocument[] IS NOT INITIAL.
      READ TABLE lt_billingdocument INTO DATA(ls_bill) INDEX 1.
    ENDIF.

    IF sy-subrc = 0.

      UPDATE zetr_t_r101
         SET "pymty   = @ls_bill-customerpaymentterms,      " Örn: doğru mapping'i sen belirleyeceksin
             inc01   = @ls_bill-incotermsclassification,
             inc02   = @ls_bill-incotermstransferlocation,
*             kunrg   = @ls_bill-transactioncurrency,
             chind   = @ls_sales-shippingtype
       WHERE filen   = @lv_export_no.
    ENDIF.


*    TYPES: BEGIN OF tys_invoices,
*             billingdocument TYPE i_billingdocument-billingdocument,
*           END OF tys_invoices.
*
*    DATA: lt_invoices TYPE STANDARD TABLE OF tys_invoices,
*          ls_invoice  TYPE tys_invoices.
*
*    DATA(lt_split)    = VALUE string_table( ).
*    DATA(invoice_key) = VALUE #( keys[ 1 ] OPTIONAL ).
*
*    IF invoice_key-%param IS INITIAL.
*      " Hata mesajı döndür
*      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
*                                          number   = '000'
*                                          severity = if_abap_behv_message=>severity-error
*                                          v1       = 'Lütfen belge numarası giriniz.' ) ) TO reported-zetr_ddl_c_exp_invoice.
*      RETURN.
*    ENDIF.
*
*    " Gelen keyleri ayır
*    DATA(lv_invoice_keys) = invoice_key-%param-content.
*    SPLIT lv_invoice_keys AT ';' INTO TABLE lt_split.
*
*    LOOP AT lt_split INTO DATA(lv_value).
*      ls_invoice-billingdocument = lv_value.
*      APPEND ls_invoice TO lt_invoices.
*    ENDLOOP.
*
*    " Item seviyesinde ağırlık ve hacim bilgilerini oku
*    SELECT billingdocument,
*           billingdocumentitem,
*           itemgrossweight,
*           itemnetweight,
*           itemweightunit,
*           itemvolume,
*           itemvolumeunit
*      FROM i_billingdocumentitem
*       FOR ALL ENTRIES IN @lt_invoices
*     WHERE billingdocument = @lt_invoices-billingdocument
*      INTO TABLE @DATA(lt_billingdocumentitem).

*    IF sy-subrc <> 0.
*      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
*                                          number   = '001'
*                                          severity = if_abap_behv_message=>severity-error
*                                          v1       = 'Belge için item bulunamadı.' ) ) TO reported-zetr_ddl_c_exp_invoice.
*      RETURN.
*    ENDIF.
*
*    " --- Hesaplamalar
*    DATA(lv_weight_unit) = VALUE string( ).
*    DATA(lv_volume_unit) = VALUE string( ).
*    DATA(lv_gross_total) = 0.
*    DATA(lv_net_total)   = 0.
*    DATA(lv_vol_total)   = 0.

*    LOOP AT lt_billingdocumentitem ASSIGNING FIELD-SYMBOL(<ls_item>).
*
*
*      IF lv_weight_unit IS INITIAL.
*        lv_weight_unit = <ls_item>-itemweightunit.
*      ENDIF.
*
*      IF <ls_item>-itemweightunit = lv_weight_unit.
*        lv_gross_total = lv_gross_total + <ls_item>-itemgrossweight.
*        lv_net_total   = lv_net_total   + <ls_item>-itemnetweight.
*      ELSE.
*        CLEAR: lv_gross_total, lv_net_total.
*        lv_weight_unit = ''.
*      ENDIF.
*
*      " Volume Unit kontrolü
*      IF lv_volume_unit IS INITIAL.
*        lv_volume_unit = <ls_item>-itemvolumeunit.
*      ENDIF.
*
*      IF <ls_item>-itemvolumeunit = lv_volume_unit.
*        lv_vol_total = lv_vol_total + <ls_item>-itemvolume.
*      ELSE.
*        CLEAR lv_vol_total.
*        lv_volume_unit = ''.
*      ENDIF.
*
*    ENDLOOP.
*
*    IF lv_weight_unit IS INITIAL.
*      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
*                                          number   = '002'
*                                          severity = if_abap_behv_message=>severity-warning
*                                           v1       = 'Ağırlık birimleri farklı olduğu için toplam yapılamadı.' ) ) TO reported-zetr_ddl_c_exp_invoice.
*    ELSE.
*
*    ENDIF.
*
*    IF lv_volume_unit IS INITIAL.
*      APPEND VALUE #( %msg = new_message( id       = 'ZETR_COMMON'
*                                          number   = '003'
*                                          severity = if_abap_behv_message=>severity-warning
*                                          v1       = 'Hacim birimleri farklı olduğu için toplam yapılamadı.' ) ) TO reported-zetr_ddl_c_exp_invoice.
*    ELSE.
*
*
*
*    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_c_exp_invoice DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_c_exp_invoice IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.