CLASS lhc_zetr_ddl_i_export_invh DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zetr_ddl_i_export_invh RESULT result.


    METHODS navigatednewpage FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_export_invh~navigatednewpage RESULT result.

    METHODS getpdf FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_i_export_invh~getpdf RESULT result.

ENDCLASS.

CLASS lhc_zetr_ddl_i_export_invh IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD navigatednewpage.

  ENDMETHOD.

  METHOD getpdf.
    LOOP AT keys INTO DATA(ls_key).
      DATA lv_button_id TYPE string.

      lv_button_id = ls_key-%param-buttonid.

      TRY.
          zbp_etr_ddl_i_prn_opr=>call_pdf( EXPORTING iv_button_id       = lv_button_id
                                                     iv_export_no       = ls_key-fileexportnumber
                                                     iv_billingdocument = ls_key-billingdocument
                                           IMPORTING ev_pdf             = DATA(lv_pdf)
                                                     ev_response_code   = DATA(lv_response_code)
                                                     ev_response_text   = DATA(lv_response_text) ).

          result = VALUE #( ( billingdocument  = ls_key-billingdocument
                              fileexportnumber = ls_key-fileexportnumber
                              %param-content   = lv_pdf  ) ) .

        CATCH cx_http_dest_provider_error.
          "handle exception
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zetr_ddl_i_exp_head DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zetr_ddl_i_exp_head IMPLEMENTATION.


  METHOD save_modified.

    DATA: lt_main        TYPE TABLE OF zetr_t_r101,
          ls_update_data TYPE zetr_t_r101,
          lt_exporttext  TYPE TABLE OF zetr_t_exp123,
          lt_dele        TYPE RANGE OF zetr_e_filen,
          lv_filen       TYPE zetr_e_filen.

    DATA: tb_struct TYPE REF TO cl_abap_structdescr,
          tb_comp   TYPE        abap_component_tab.

    FIELD-SYMBOLS: <fs_name>         TYPE any,
                   <fs_update_data>  TYPE any,
                   <fs_export_value> TYPE any.

    IF create-zetr_ddl_i_exp_head IS NOT INITIAL.
      TRY.
          cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr       = '10'
                                                        object            = 'ZETR_EXP'
                                              IMPORTING number            = DATA(number_range_key)
                                                        returncode        = DATA(number_range_return_code)
                                                        returned_quantity = DATA(number_range_returned_quantity) ).

        CATCH cx_nr_object_not_found cx_number_ranges INTO DATA(lo_number).
          APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                        text     = lo_number->get_text( ) ) ) TO reported-zetr_ddl_i_exp_head.
      ENDTRY.

      lv_filen = |{ number_range_key ALPHA = OUT }|.

      LOOP AT create-zetr_ddl_i_exp_head INTO DATA(ls_create).
        APPEND INITIAL LINE TO lt_main ASSIGNING FIELD-SYMBOL(<ls_main>).
        MOVE-CORRESPONDING ls_create TO <ls_main>.
        <ls_main>-filen = lv_filen.
      ENDLOOP.

      SELECT * FROM zetr_ddl_c_txt_typ WHERE language = @sy-langu INTO TABLE @DATA(lt_texts).

      LOOP AT lt_texts ASSIGNING FIELD-SYMBOL(<fs_text>).
        APPEND INITIAL LINE TO lt_exporttext ASSIGNING FIELD-SYMBOL(<fs_exporttext>).
        <fs_exporttext>-filen      = lv_filen.
        <fs_exporttext>-objecttype = <fs_text>-textkey.
      ENDLOOP.

      IF lt_main IS NOT INITIAL.
        INSERT zetr_t_r101 FROM TABLE @lt_main.
      ENDIF.

      IF lt_exporttext IS NOT INITIAL.
        INSERT zetr_t_exp123 FROM TABLE @lt_exporttext.
      ENDIF.

      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                    text     = |{ lv_filen } yaratılmıştır.| )
                                                        filen = lv_filen ) TO reported-zetr_ddl_i_exp_head.
    ENDIF.

    IF update-zetr_ddl_i_exp_head IS NOT INITIAL.
      DATA(ls_exp_header) = VALUE #( update-zetr_ddl_i_exp_head[ 1 ] OPTIONAL ).

      SELECT SINGLE * FROM zetr_t_r101 WHERE filen = @ls_exp_header-filen INTO @DATA(ls_r101) .

      LOOP AT update-zetr_ddl_i_exp_head INTO DATA(ls_update).
        tb_struct ?= cl_abap_typedescr=>describe_by_data( ls_update-%control ).

        LOOP AT tb_struct->components ASSIGNING FIELD-SYMBOL(<fs_components>).
          ASSIGN COMPONENT <fs_components>-name OF STRUCTURE ls_update-%control TO <fs_name>.

          IF <fs_name> = if_abap_behv=>mk-on.
            ASSIGN COMPONENT <fs_components>-name OF STRUCTURE ls_update TO <fs_update_data>.
            ASSIGN COMPONENT <fs_components>-name OF STRUCTURE ls_r101   TO <fs_export_value>.
            <fs_export_value> = <fs_update_data>.
          ENDIF.
        ENDLOOP.

      ENDLOOP.

      IF ls_r101 IS NOT INITIAL.
        MODIFY zetr_t_r101 FROM @ls_r101.
      ENDIF.

      APPEND VALUE #( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                                    text     = | { ls_r101-filen } numaralı dosya güncellenmiştir.| )

                                                    filen = lv_filen
                                                     ) TO reported-zetr_ddl_i_exp_head.
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