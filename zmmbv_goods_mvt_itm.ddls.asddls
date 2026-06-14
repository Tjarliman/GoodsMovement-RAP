//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement Item - Base CDS View (Child Entity)
// Program Name: ZMMBV_GOODS_MVT_ITM
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
@EndUserText.label: 'MM-I-005: Goods Movement Item'
define view entity ZMMBV_GOODS_MVT_ITM
  as select from zmmt_gmvt_i
  association to parent ZMMBV_GOODS_MVT_HDR as _Header
    on $projection.MessageID = _Header.MessageID
  composition [0..*] of ZMMBV_GOODS_MVT_SER as _Serials
{
  key msgid          as MessageID,
  key item_no        as Item,
      material_long  as Material,
      plant          as Plant,
      stge_loc       as StorageLocation,
      move_type      as MovementType,
      stck_type      as StockType,
      entry_qnt      as Quantity,
      entry_uom      as UOM,
      reserv_no      as ReservationNumber,
      res_item       as ReservationItemNo,
      matdoc_itm     as MaterialDocumentItem,

      _Header,
      _Serials
}
