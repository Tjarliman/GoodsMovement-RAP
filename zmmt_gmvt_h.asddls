//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement Header - Staging/Log Table
// Program Name: ZMMT_GMVT_H
// Created By  : <Developer Name>
// Create Date : 13-06-2026
// TR No.      : <TR Number>
//----------------------------------------------------------------------
// Modification History
//----------------------------------------------------------------------
// Defect/CR No.  Name          Date          Request No.  Description
//----------------------------------------------------------------------
// CRxxx          XXXXXXX       DD-MMM-YYYY   xxxxx        XXXX
//----------------------------------------------------------------------

@EndUserText.label : 'MM-I-005: Goods Movement Header'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmmt_gmvt_h {

  key client     : abap.clnt not null;
  key msgid      : abap.char(32) not null;
  partner        : abap.char(50);
  partner_msgid  : abap.char(50);
  gm_code        : abap.char(2);
  pstng_date     : abap.dats;
  doc_date       : abap.dats;
  ref_doc_no     : abap.char(16);
  header_txt     : abap.char(25);
  mat_doc        : abap.char(10);
  mat_doc_year   : gjahr;
  created_by     : abap.char(12);
  created_at     : timestampl;

}
