//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement - Service Definition (Web API)
// Program Name: ZMMSD_GOODS_MVT
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

@EndUserText.label: 'MM-I-005: Goods Movement API'
define service ZMMSD_GOODS_MVT {
  expose ZMMBV_GOODS_MVT_HDR as GoodsMovement;
  expose ZMMBV_GOODS_MVT_ITM as GoodsMovementItem;
  expose ZMMBV_GOODS_MVT_SER as GoodsMovementSerial;
}
