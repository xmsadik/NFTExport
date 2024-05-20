  method BDW_REFERENCE_REQUEST_IN.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'BDW_REFERENCE_REQUEST_IN'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.