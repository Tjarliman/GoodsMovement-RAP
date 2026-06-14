//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement - Behavior Definition (Unmanaged)
// Program Name: ZMMBV_GOODS_MVT_HDR
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

unmanaged implementation in class ZMMCL_BP_GOODS_MVT unique;

define behavior for ZMMBV_GOODS_MVT_HDR alias Header
lock master
authorization master ( instance )
{
  create;

  field ( readonly ) MaterialDocument, MaterialDocumentYear,
                     CreatedBy, CreatedAt;

  mapping for zmmt_gmvt_h corresponding
  {
    MessageID            = msgid;
    PartnerName          = partner;
    PartnerMessageID     = partner_msgid;
    GoodsMovementCode    = gm_code;
    PostingDate          = pstng_date;
    DocumentDate         = doc_date;
    ReferenceDocument    = ref_doc_no;
    HeaderText           = header_txt;
    MaterialDocument     = mat_doc;
    MaterialDocumentYear = mat_doc_year;
    CreatedBy            = created_by;
    CreatedAt            = created_at;
  }

  association _Items { create; }
}

define behavior for ZMMBV_GOODS_MVT_ITM alias Item
lock dependent by _Header
authorization dependent by _Header
{
  field ( readonly ) MessageID, Item;

  mapping for zmmt_gmvt_i corresponding
  {
    MessageID            = msgid;
    Item                 = item_no;
    Material             = material_long;
    Plant                = plant;
    StorageLocation      = stge_loc;
    MovementType         = move_type;
    StockType            = stck_type;
    Quantity             = entry_qnt;
    UOM                  = entry_uom;
    ReservationNumber    = reserv_no;
    ReservationItemNo    = res_item;
    MaterialDocumentItem = matdoc_itm;
  }

  association _Header;
  association _Serials { create; }
}

define behavior for ZMMBV_GOODS_MVT_SER alias Serial
{
  field ( readonly ) MessageID, Item, SerialSequence;

  mapping for zmmt_gmvt_s corresponding
  {
    MessageID        = msgid;
    Item             = item_no;
    SerialSequence   = serial_seq;
    SerialNumber     = serialno;
    UniqueIdentifier = uii;
  }

  association _Item;
}
