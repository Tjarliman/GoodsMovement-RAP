//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement Serial - Base CDS View (Grandchild Entity)
// Program Name: ZMMBV_GOODS_MVT_SER
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

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM-I-005: Goods Movement Serial'
define view entity ZMMBV_GOODS_MVT_SER
  as select from zmmt_gmvt_s
  association to parent ZMMBV_GOODS_MVT_ITM as _Item
    on  $projection.MessageID = _Item.MessageID
    and $projection.Item      = _Item.Item
{
  key msgid       as MessageID,
  key item_no     as Item,
  key serial_seq  as SerialSequence,
      serialno    as SerialNumber,
      uii         as UniqueIdentifier,

      _Item
}
