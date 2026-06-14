//----------------------------------------------------------------------
// Project     : Goods Movement Interface
// RICEFW ID   : MM-I-005
// Description : Goods Movement Header - Base CDS View (Root Entity)
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

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM-I-005: Goods Movement Header'
define root view entity ZMMBV_GOODS_MVT_HDR
  as select from zmmt_gmvt_h
  composition [0..*] of ZMMBV_GOODS_MVT_ITM as _Items
{
  key msgid          as MessageID,
      partner        as PartnerName,
      partner_msgid  as PartnerMessageID,
      gm_code        as GoodsMovementCode,
      pstng_date     as PostingDate,
      doc_date       as DocumentDate,
      ref_doc_no     as ReferenceDocument,
      header_txt     as HeaderText,
      mat_doc        as MaterialDocument,
      mat_doc_year   as MaterialDocumentYear,
      created_by     as CreatedBy,
      created_at     as CreatedAt,

      _Items
}
