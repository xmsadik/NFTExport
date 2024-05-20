managed implementation in class zbp_etr_ddl_i_tax_cde unique;
strict ( 2 );

define behavior for ZETR_DDL_I_TAX_CDE //alias <alias_name>
persistent table zetr_t_exp109
lock master
authorization master ( instance )
//etag master <field_name>
{


  mapping for zetr_t_exp109
    {
      Vorgang = vorgang;
      Kalsm   = kalsm;
      Mwskz   = mwskz;
    }

  field ( readonly ) VorgangText;
  create;
  update;
  delete;
}