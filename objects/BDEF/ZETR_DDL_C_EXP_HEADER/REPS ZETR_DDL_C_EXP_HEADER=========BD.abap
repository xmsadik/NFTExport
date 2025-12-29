projection implementation in class zbp_etr_ddl_c_exp_header unique;
strict;

define behavior for ZETR_DDL_C_EXP_HEADER
{
  use create;
  use update;
  use delete;

  action releaseToAccounting;
  action ClosedExport;


  use association _InvoiceHeader;
  use association _InvoiceItem;
  use association _Texts { create; }
  use association _BillingDocument;
  use association _Costing;
}


define behavior for ZETR_DDL_C_EXP_INVH
{

  use action getpdf;
  action navigatedNewPage;
  use delete;

  use association _ExportFile;

}

define behavior for ZETR_DDL_C_EXP_INVI
{
  use delete;

  use association _ExportFile;

}


define behavior for ZETR_DDL_C_EXP_TXT
{
  use update;
  use delete;

  use association _ExportFile;

}

define behavior for ZETR_DDL_C_BIL_DOC
{

  action releaseToAccountingBilDoc;

  use association _ExportFile;

}

define behavior for ZETR_DDL_C_COSTING_RPR
{

  use association _ExportFile;

}