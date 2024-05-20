CLASS lhc_zetr_ddl_i_export_invh DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_export_invh RESULT result.


    METHODS navigatednewpage FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_export_invh~navigatednewpage RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_export_invh IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD navigatednewpage.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_exp_head DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_exp_head IMPLEMENTATION.


  METHOD save_modified.

    DATA: lt_main       TYPE TABLE OF zetr_t_r101,
          lt_exporttext TYPE TABLE OF zetr_t_exp123,
          lt_dele       TYPE RANGE OF zetr_e_filen,
          lv_filen      TYPE zetr_e_filen.

*    IF create-zetr_ddl_i_exp_head IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr       = '10'
                                                      object            = 'ZETR_EXP'
                                            IMPORTING number            = DATA(number_range_key)
                                                      returncode        = DATA(number_range_return_code)
                                                      returned_quantity = DATA(number_range_returned_quantity) ).

      CATCH cx_nr_object_not_found cx_number_ranges INTO DATA(lo_number).
    ENDTRY.

    lv_filen = |{ number_range_key ALPHA = OUT }|.

    SELECT * FROM i_textobjecttypetext
     WHERE textobjectcategory = 'VBBK'
       AND textobjecttype     LIKE 'TX%'
       AND language           = @sy-langu
      INTO TABLE @DATA(lt_texts).


    LOOP AT lt_texts ASSIGNING FIELD-SYMBOL(<fs_text>).
      APPEND INITIAL LINE TO lt_exporttext ASSIGNING FIELD-SYMBOL(<fs_exporttext>).
      <fs_exporttext>-filen      = lv_filen.
      <fs_exporttext>-objecttype = <fs_text>-textobjecttype.
    ENDLOOP.

*    ENDIF.

    LOOP AT create-zetr_ddl_i_exp_head INTO DATA(ls_create).
      APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
      MOVE-CORRESPONDING ls_create TO <ls_main>.
      <ls_main>-filen = lv_filen.
    ENDLOOP.

*    LOOP AT update-zetr_ddl_i_exp_head INTO DATA(ls_update).
*      MOVE-CORRESPONDING ls_update TO <ls_main>.
*    ENDLOOP.
*
*    LOOP AT delete-zetr_ddl_i_exp_head INTO DATA(ls_delete).
*      APPEND INITIAL LINE TO lt_dele ASSIGNING FIELD-SYMBOL(<ls_dele>).
*
*      <ls_dele> = VALUE #( low    = ls_delete-filen
*                           sign   = 'I'
*                           option = 'EQ'  ).
*    ENDLOOP.

*    IF lt_dele IS NOT INITIAL.
*      DELETE FROM zetr_t_r101 WHERE filen IN @lt_dele.
*    ENDIF.

    IF lt_main IS NOT INITIAL.
      INSERT zetr_t_r101 FROM TABLE @lt_main.
    ENDIF.

    IF lt_exporttext IS NOT INITIAL.
      INSERT zetr_t_exp123 FROM TABLE @lt_exporttext.
    ENDIF.

  ENDMETHOD.


ENDCLASS.

CLASS lhc_zetr_ddl_i_exp_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_exp_head RESULT result.
    METHODS releasetoaccounting FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_exp_head~releasetoaccounting.

ENDCLASS.

CLASS lhc_zetr_ddl_i_exp_head IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD releasetoaccounting.
    DATA(lv_deneme) = 1.

  ENDMETHOD.

ENDCLASS.