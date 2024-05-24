CLASS lhc_zetr_ddl_c_exp_header DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS releasetoaccounting FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_c_exp_header~releasetoaccounting.



ENDCLASS.

CLASS lhc_zetr_ddl_c_exp_header IMPLEMENTATION.

  METHOD releasetoaccounting.

    MODIFY ENTITIES OF zetr_ddl_c_exp_header IN LOCAL MODE
       ENTITY zetr_ddl_c_exp_header
        UPDATE
         FROM VALUE #( FOR key IN keys INDEX INTO i ( %tky = key-%tky
                                              isaccounting = 'X'   ) )
       REPORTED DATA(updated_reported).


    APPEND VALUE #( %msg = new_message( id       = 'ZETR_EXP'
                                        number   = '004'
                                        severity = if_abap_behv_message=>severity-success ) ) TO reported-zetr_ddl_c_exp_header.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zetr_ddl_c_exp_invh DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS navigatednewpage FOR MODIFY
      IMPORTING keys FOR ACTION zetr_ddl_c_exp_invh~navigatednewpage.


ENDCLASS.

CLASS lhc_zetr_ddl_c_exp_invh IMPLEMENTATION.

  METHOD navigatednewpage.
  ENDMETHOD.

ENDCLASS.