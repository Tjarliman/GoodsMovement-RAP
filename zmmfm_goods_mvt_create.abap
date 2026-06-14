*----------------------------------------------------------------------*
* Project     : Goods Movement Interface
* RICEFW ID   : MM-I-005
* Description : Goods Movement - RFC Wrapper for BAPI_GOODSMVT_CREATE
* Program Name: ZMMFM_GOODS_MVT_CREATE
* Function Grp: ZMMFG_GOODS_MVT
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

FUNCTION zmmfm_goods_mvt_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_GM_HEADER) TYPE  BAPI2017_GM_HEAD_01
*"     VALUE(IS_GM_CODE)   TYPE  BAPI2017_GM_CODE
*"  EXPORTING
*"     VALUE(EV_MATDOC)    TYPE  BAPI2017_GM_HEAD_RET-MAT_DOC
*"     VALUE(EV_MATYEAR)   TYPE  BAPI2017_GM_HEAD_RET-DOC_YEAR
*"  TABLES
*"     T_GM_ITEMS          STRUCTURE  BAPI2017_GM_ITEM_CREATE
*"     T_GM_SERIAL         STRUCTURE  BAPI2017_GM_SERIALNUMBER
*"     T_RETURN            STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header       = is_gm_header
      goodsmvt_code         = is_gm_code
    IMPORTING
      materialdocument      = ev_matdoc
      matdocumentyear       = ev_matyear
    TABLES
      goodsmvt_item         = t_gm_items
      goodsmvt_serialnumber = t_gm_serial
      return                = t_return.

  IF ev_matdoc IS NOT INITIAL.
    COMMIT WORK AND WAIT.
  ELSE.
    ROLLBACK WORK.
  ENDIF.

ENDFUNCTION.
