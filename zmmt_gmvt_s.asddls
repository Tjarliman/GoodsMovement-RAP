//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement Serial Number - Staging/Log Table
// Program Name: ZMMT_GMVT_S
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

@EndUserText.label : 'MM-I-005: Goods Movement Serial'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmmt_gmvt_s {

  key client     : abap.clnt not null;
  key msgid      : abap.char(32) not null;
  key item_no    : abap.numc(4) not null;
  key serial_seq : abap.numc(4) not null;
  serialno       : abap.char(18);
  uii            : abap.char(72);

}
