CLASS zbp_etr_ddl_i_prn_opr DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zetr_ddl_i_prn_opr.

  PUBLIC SECTION.
    CLASS-METHODS:
      prepare_pdf IMPORTING iv_button_id     TYPE string
                            iv_export_no     TYPE zetr_e_filen
                  EXPORTING ev_pdf           TYPE string
                            ev_response_code TYPE int4
                            ev_response_text TYPE string
                  RAISING   cx_http_dest_provider_error,

      call_adobe IMPORTING iv_form_name      TYPE string
                           iv_template_name  TYPE string
                           iv_xml            TYPE string
                           iv_queue_name     TYPE string OPTIONAL
                           iv_comm_scenario  TYPE if_com_management=>ty_cscn_id
                           iv_comm_system_id TYPE if_com_management=>ty_cs_id
                           iv_service_id     TYPE if_com_management=>ty_cscn_outb_srv_id
                 EXPORTING ev_pdf            TYPE string
                           ev_response_code  TYPE int4
                           ev_response_text  TYPE string
                 RAISING   cx_http_dest_provider_error.


    TYPES: BEGIN OF ty_abap_parmbind,
             name  TYPE c LENGTH 30,
             kind  TYPE c LENGTH 1,
             value TYPE REF TO data,
           END OF ty_abap_parmbind.

    TYPES: ty_abap_parmbind_tab TYPE STANDARD TABLE OF ty_abap_parmbind WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_abap_excpbind,
             name  TYPE c LENGTH 30,
             value TYPE i,
           END OF ty_abap_excpbind.

    TYPES : ty_abap_excpbind_tab TYPE STANDARD TABLE OF ty_abap_excpbind WITH DEFAULT KEY.


    INTERFACES if_oo_adt_classrun.
