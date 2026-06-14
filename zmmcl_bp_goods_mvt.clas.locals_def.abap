*----------------------------------------------------------------------*
* Project     : Goods Movement Interface
* RICEFW ID   : MM-I-005
* Description : Goods Movement - Local Buffer Definition
* Program Name: ZMMCL_BP_GOODS_MVT
* Created By  : <Developer Name>
* Create Date : 13-06-2026
* TR No.      : <TR Number>
*----------------------------------------------------------------------*
* Modification History
*----------------------------------------------------------------------*
* Defect/CR No.  Name          Date          Request No.  Description
*----------------------------------------------------------------------*
* CRxxx          XXXXXXX       DD-MMM-YYYY   xxxxx        XXXX
*----------------------------------------------------------------------*

CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_bapi_result,
             msgid        TYPE sysuuid_x16,
             mat_doc      TYPE bapi2017_gm_head_ret-mat_doc,
             mat_doc_year TYPE bapi2017_gm_head_ret-doc_year,
           END OF ty_bapi_result.

    CLASS-DATA: gt_header  TYPE TABLE OF zmmt_gmvt_h,
                gt_item    TYPE TABLE OF zmmt_gmvt_i,
                gt_serial  TYPE TABLE OF zmmt_gmvt_s,
                gt_results TYPE TABLE OF ty_bapi_result.

    CLASS-METHODS clear.
ENDCLASS.

CLASS lcl_buffer IMPLEMENTATION.
  METHOD clear.
    CLEAR: gt_header, gt_item, gt_serial, gt_results.
  ENDMETHOD.
ENDCLASS.
