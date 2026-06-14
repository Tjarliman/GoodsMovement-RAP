//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement Item - Staging/Log Table
// Program Name: ZMMT_GMVT_I
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

@EndUserText.label : 'MM-I-005: Goods Movement Item'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #RESTRICTED
define table zmmt_gmvt_i {

  key client        : abap.clnt not null;
  key msgid         : sysuuid_x16 not null;
  key item_no       : abap.numc(4) not null;
  material_long     : abap.char(40);
  plant             : abap.char(4);
  stge_loc          : abap.char(4);
  move_type         : abap.char(3);
  stck_type         : abap.char(1);
  @Semantics.quantity.unitOfMeasure : 'zmmt_gmvt_i.entry_uom'
  entry_qnt         : abap.quan(13,3);
  entry_uom         : abap.unit(3);
  reserv_no         : abap.char(10);
  res_item          : abap.numc(4);
  matdoc_itm        : abap.numc(4);

}
