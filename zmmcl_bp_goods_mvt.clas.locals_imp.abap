*----------------------------------------------------------------------*
* Project     : Goods Movement Interface
* RICEFW ID   : MM-I-005
* Description : Goods Movement - Behavior Handlers & Saver
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


**********************************************************************
* Handler: Header
**********************************************************************
CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Header.

    METHODS cba_items FOR MODIFY
      IMPORTING entities_cba FOR CREATE Header\_Items.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Header.

    METHODS read FOR READ
      IMPORTING keys FOR READ Header RESULT result.

    METHODS rba_items FOR READ
      IMPORTING keys_rba FOR READ Header\_Items
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      APPEND VALUE #( %tky = <key>-%tky ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD create.
    DATA ls_header TYPE zmmt_gmvt_h.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      TRY.
          ls_header-msgid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
          APPEND VALUE #( %cid = <entity>-%cid ) TO failed-header.
          APPEND VALUE #( %cid = <entity>-%cid
                          %msg = new_message_with_text(
                                   text     = 'UUID generation failed'
                                   severity = if_abap_behv_message=>severity-error )
                        ) TO reported-header.
          CONTINUE.
      ENDTRY.

      ls_header-partner       = <entity>-PartnerName.
      ls_header-partner_msgid = <entity>-PartnerMessageID.
      ls_header-gm_code       = <entity>-GoodsMovementCode.
      ls_header-pstng_date    = <entity>-PostingDate.
      ls_header-doc_date      = <entity>-DocumentDate.
      ls_header-ref_doc_no    = <entity>-ReferenceDocument.
      ls_header-header_txt    = <entity>-HeaderText.
      ls_header-created_by    = sy-uname.
      GET TIME STAMP FIELD ls_header-created_at.

      APPEND ls_header TO lcl_buffer=>gt_header.

      APPEND VALUE #( %cid      = <entity>-%cid
                       MessageID = ls_header-msgid ) TO mapped-header.

    ENDLOOP.
  ENDMETHOD.

  METHOD cba_items.
    DATA ls_item   TYPE zmmt_gmvt_i.
    DATA lv_uom_int TYPE meins.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<header>).
      LOOP AT <header>-%target ASSIGNING FIELD-SYMBOL(<item>).

        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
          EXPORTING
            input    = <item>-UOM
            language = sy-langu
          IMPORTING
            output   = lv_uom_int
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
          APPEND VALUE #( %cid = <item>-%cid ) TO failed-item.
          APPEND VALUE #( %cid = <item>-%cid
                          %msg = new_message_with_text(
                                   text     = |Unit of measure '{ <item>-UOM }' not found|
                                   severity = if_abap_behv_message=>severity-error )
                        ) TO reported-item.
          CONTINUE.
        ENDIF.

        ls_item-msgid         = <header>-MessageID.
        ls_item-item_no       = <item>-Item.
        ls_item-material_long = <item>-Material.
        ls_item-plant         = <item>-Plant.
        ls_item-stge_loc      = <item>-StorageLocation.
        ls_item-move_type     = <item>-MovementType.
        ls_item-stck_type     = <item>-StockType.
        ls_item-entry_qnt     = <item>-Quantity.
        ls_item-entry_uom     = lv_uom_int.
        ls_item-reserv_no     = <item>-ReservationNumber.
        ls_item-res_item      = <item>-ReservationItemNo.
        ls_item-matdoc_itm    = <item>-MaterialDocumentItem.

        APPEND ls_item TO lcl_buffer=>gt_item.

        APPEND VALUE #( %cid      = <item>-%cid
                         MessageID = <header>-MessageID
                         Item      = <item>-Item ) TO mapped-item.

      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    " No locking needed for Web API scenario
  ENDMETHOD.

  METHOD read.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      READ TABLE lcl_buffer=>gt_header
        WITH KEY msgid = <key>-MessageID
        ASSIGNING FIELD-SYMBOL(<buf>).
      IF sy-subrc = 0.
        APPEND VALUE #(
          MessageID            = <buf>-msgid
          PartnerName          = <buf>-partner
          PartnerMessageID     = <buf>-partner_msgid
          GoodsMovementCode    = <buf>-gm_code
          PostingDate          = <buf>-pstng_date
          DocumentDate         = <buf>-doc_date
          ReferenceDocument    = <buf>-ref_doc_no
          HeaderText           = <buf>-header_txt
          MaterialDocument     = <buf>-mat_doc
          MaterialDocumentYear = <buf>-mat_doc_year
          CreatedBy            = <buf>-created_by
          CreatedAt            = <buf>-created_at
        ) TO result.
      ELSE.
        APPEND VALUE #( MessageID = <key>-MessageID ) TO failed-header.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_items.
    LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<key>).
      LOOP AT lcl_buffer=>gt_item ASSIGNING FIELD-SYMBOL(<buf>)
        WHERE msgid = <key>-MessageID.
        IF result_requested = abap_true.
          APPEND VALUE #(
            MessageID            = <buf>-msgid
            Item                 = <buf>-item_no
            Material             = <buf>-material_long
            Plant                = <buf>-plant
            StorageLocation      = <buf>-stge_loc
            MovementType         = <buf>-move_type
            StockType            = <buf>-stck_type
            Quantity             = <buf>-entry_qnt
            UOM                  = <buf>-entry_uom
            ReservationNumber    = <buf>-reserv_no
            ReservationItemNo    = <buf>-res_item
            MaterialDocumentItem = <buf>-matdoc_itm
          ) TO result.
        ENDIF.
        APPEND VALUE #(
          source-%key = <key>-%key
          target-MessageID = <buf>-msgid
          target-Item      = <buf>-item_no
        ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.


**********************************************************************
* Handler: Item
**********************************************************************
CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS cba_serials FOR MODIFY
      IMPORTING entities_cba FOR CREATE Item\_Serials.

    METHODS read FOR READ
      IMPORTING keys FOR READ Item RESULT result.

    METHODS rba_header FOR READ
      IMPORTING keys_rba FOR READ Item\_Header
      FULL result_requested RESULT result LINK association_links.

    METHODS rba_serials FOR READ
      IMPORTING keys_rba FOR READ Item\_Serials
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD cba_serials.
    DATA ls_serial TYPE zmmt_gmvt_s.
    DATA lv_seq    TYPE numc4.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<item>).
      LOOP AT <item>-%target ASSIGNING FIELD-SYMBOL(<serial>).

        lv_seq = 0.
        LOOP AT lcl_buffer=>gt_serial TRANSPORTING NO FIELDS
          WHERE msgid   = <item>-MessageID
            AND item_no = <item>-Item.
          lv_seq += 1.
        ENDLOOP.
        lv_seq += 1.

        ls_serial-msgid      = <item>-MessageID.
        ls_serial-item_no    = <item>-Item.
        ls_serial-serial_seq = lv_seq.
        ls_serial-serialno   = <serial>-SerialNumber.
        ls_serial-uii        = <serial>-UniqueIdentifier.

        APPEND ls_serial TO lcl_buffer=>gt_serial.

        APPEND VALUE #( %cid           = <serial>-%cid
                         MessageID      = <item>-MessageID
                         Item           = <item>-Item
                         SerialSequence = lv_seq ) TO mapped-serial.

      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      READ TABLE lcl_buffer=>gt_item
        WITH KEY msgid   = <key>-MessageID
                 item_no = <key>-Item
        ASSIGNING FIELD-SYMBOL(<buf>).
      IF sy-subrc = 0.
        APPEND VALUE #(
          MessageID            = <buf>-msgid
          Item                 = <buf>-item_no
          Material             = <buf>-material_long
          Plant                = <buf>-plant
          StorageLocation      = <buf>-stge_loc
          MovementType         = <buf>-move_type
          StockType            = <buf>-stck_type
          Quantity             = <buf>-entry_qnt
          UOM                  = <buf>-entry_uom
          ReservationNumber    = <buf>-reserv_no
          ReservationItemNo    = <buf>-res_item
          MaterialDocumentItem = <buf>-matdoc_itm
        ) TO result.
      ELSE.
        APPEND VALUE #( MessageID = <key>-MessageID
                         Item     = <key>-Item ) TO failed-item.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_header.
    LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<key>).
      READ TABLE lcl_buffer=>gt_header
        WITH KEY msgid = <key>-MessageID
        ASSIGNING FIELD-SYMBOL(<buf>).
      IF sy-subrc = 0.
        IF result_requested = abap_true.
          APPEND VALUE #(
            MessageID            = <buf>-msgid
            PartnerName          = <buf>-partner
            PartnerMessageID     = <buf>-partner_msgid
            GoodsMovementCode    = <buf>-gm_code
            PostingDate          = <buf>-pstng_date
            DocumentDate         = <buf>-doc_date
            ReferenceDocument    = <buf>-ref_doc_no
            HeaderText           = <buf>-header_txt
            MaterialDocument     = <buf>-mat_doc
            MaterialDocumentYear = <buf>-mat_doc_year
            CreatedBy            = <buf>-created_by
            CreatedAt            = <buf>-created_at
          ) TO result.
        ENDIF.
        APPEND VALUE #(
          source-%key = <key>-%key
          target-MessageID = <buf>-msgid
        ) TO association_links.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_serials.
    LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<key>).
      LOOP AT lcl_buffer=>gt_serial ASSIGNING FIELD-SYMBOL(<buf>)
        WHERE msgid   = <key>-MessageID
          AND item_no = <key>-Item.
        IF result_requested = abap_true.
          APPEND VALUE #(
            MessageID        = <buf>-msgid
            Item             = <buf>-item_no
            SerialSequence   = <buf>-serial_seq
            SerialNumber     = <buf>-serialno
            UniqueIdentifier = <buf>-uii
          ) TO result.
        ENDIF.
        APPEND VALUE #(
          source-%key = <key>-%key
          target-MessageID      = <buf>-msgid
          target-Item           = <buf>-item_no
          target-SerialSequence = <buf>-serial_seq
        ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.


**********************************************************************
* Handler: Serial
**********************************************************************
CLASS lhc_serial DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS read FOR READ
      IMPORTING keys FOR READ Serial RESULT result.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ Serial\_Item
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_serial IMPLEMENTATION.

  METHOD read.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      READ TABLE lcl_buffer=>gt_serial
        WITH KEY msgid      = <key>-MessageID
                 item_no    = <key>-Item
                 serial_seq = <key>-SerialSequence
        ASSIGNING FIELD-SYMBOL(<buf>).
      IF sy-subrc = 0.
        APPEND VALUE #(
          MessageID        = <buf>-msgid
          Item             = <buf>-item_no
          SerialSequence   = <buf>-serial_seq
          SerialNumber     = <buf>-serialno
          UniqueIdentifier = <buf>-uii
        ) TO result.
      ELSE.
        APPEND VALUE #( MessageID      = <key>-MessageID
                         Item           = <key>-Item
                         SerialSequence = <key>-SerialSequence ) TO failed-serial.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_item.
    LOOP AT keys_rba ASSIGNING FIELD-SYMBOL(<key>).
      READ TABLE lcl_buffer=>gt_item
        WITH KEY msgid   = <key>-MessageID
                 item_no = <key>-Item
        ASSIGNING FIELD-SYMBOL(<buf>).
      IF sy-subrc = 0.
        IF result_requested = abap_true.
          APPEND VALUE #(
            MessageID            = <buf>-msgid
            Item                 = <buf>-item_no
            Material             = <buf>-material_long
            Plant                = <buf>-plant
            StorageLocation      = <buf>-stge_loc
            MovementType         = <buf>-move_type
            StockType            = <buf>-stck_type
            Quantity             = <buf>-entry_qnt
            UOM                  = <buf>-entry_uom
            ReservationNumber    = <buf>-reserv_no
            ReservationItemNo    = <buf>-res_item
            MaterialDocumentItem = <buf>-matdoc_itm
          ) TO result.
        ENDIF.
        APPEND VALUE #(
          source-%key = <key>-%key
          target-MessageID = <buf>-msgid
          target-Item      = <buf>-item_no
        ) TO association_links.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.


**********************************************************************
* Saver - Calls ZMMFM_GOODS_MVT_CREATE via DESTINATION 'NONE'
**********************************************************************
CLASS lsc_save DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS check_before_save REDEFINITION.
    METHODS save             REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_save IMPLEMENTATION.

  METHOD check_before_save.

    DATA ls_gm_header  TYPE bapi2017_gm_head_01.
    DATA ls_gm_code    TYPE bapi2017_gm_code.
    DATA ls_gm_item    TYPE bapi2017_gm_item_create.
    DATA lt_gm_items   TYPE TABLE OF bapi2017_gm_item_create.
    DATA lt_gm_serial  TYPE TABLE OF bapi2017_gm_serialnumber.
    DATA lt_return      TYPE TABLE OF bapiret2.
    DATA lv_matdoc      TYPE bapi2017_gm_head_ret-mat_doc.
    DATA lv_matyear     TYPE bapi2017_gm_head_ret-doc_year.

    LOOP AT lcl_buffer=>gt_header ASSIGNING FIELD-SYMBOL(<header>).

      CLEAR: ls_gm_header, ls_gm_code, lt_gm_items, lt_gm_serial, lt_return,
             lv_matdoc, lv_matyear.

      ls_gm_header-pstng_date = <header>-pstng_date.
      ls_gm_header-doc_date   = <header>-doc_date.
      ls_gm_header-ref_doc_no = <header>-ref_doc_no.
      ls_gm_header-header_txt = <header>-header_txt.

      ls_gm_code-gm_code = <header>-gm_code.

      LOOP AT lcl_buffer=>gt_item ASSIGNING FIELD-SYMBOL(<item>)
        WHERE msgid = <header>-msgid.

        CLEAR ls_gm_item.
        ls_gm_item-material_long = <item>-material_long.
        ls_gm_item-plant         = <item>-plant.
        ls_gm_item-stge_loc      = <item>-stge_loc.
        ls_gm_item-move_type     = <item>-move_type.
        ls_gm_item-stck_type     = <item>-stck_type.
        ls_gm_item-entry_qnt     = <item>-entry_qnt.
        ls_gm_item-entry_uom     = <item>-entry_uom.

        IF <item>-reserv_no CN ' 0'.
          ls_gm_item-reserv_no = <item>-reserv_no.
          ls_gm_item-res_item  = <item>-res_item.
        ENDIF.

        APPEND ls_gm_item TO lt_gm_items.

        LOOP AT lcl_buffer=>gt_serial ASSIGNING FIELD-SYMBOL(<serial>)
          WHERE msgid   = <header>-msgid
            AND item_no = <item>-item_no.

          APPEND VALUE bapi2017_gm_serialnumber(
            matdoc_itm = <item>-matdoc_itm
            serialno   = <serial>-serialno
            uii        = <serial>-uii
          ) TO lt_gm_serial.

        ENDLOOP.

      ENDLOOP.

      CALL FUNCTION 'ZMMFM_GOODSMVT_CREATE'
        DESTINATION 'NONE'
        EXPORTING
          goodsmvt_header  = ls_gm_header
          goodsmvt_code    = ls_gm_code
          commit_work      = abap_true
        IMPORTING
          materialdocument = lv_matdoc
          matdocumentyear  = lv_matyear
        TABLES
          goodsmvt_item         = lt_gm_items
          goodsmvt_serialnumber = lt_gm_serial
          return                = lt_return
        EXCEPTIONS
          system_failure        = 1
          communication_failure = 2
          OTHERS                = 3.

      IF sy-subrc <> 0.
        APPEND VALUE #( MessageID = <header>-msgid ) TO failed-header.
        APPEND VALUE #(
          MessageID = <header>-msgid
          %msg = new_message_with_text(
                   text     = |RFC call failed: { sy-msgv1 }|
                   severity = if_abap_behv_message=>severity-error )
        ) TO reported-header.
        CONTINUE.
      ENDIF.

      DATA lv_failed TYPE abap_bool.

      IF lv_matdoc IS NOT INITIAL.

        lv_failed = abap_false.

        APPEND VALUE lcl_buffer=>ty_bapi_result(
          msgid        = <header>-msgid
          mat_doc      = lv_matdoc
          mat_doc_year = lv_matyear
        ) TO lcl_buffer=>gt_results.

      ELSE.

        lv_failed = abap_true.

        APPEND VALUE #( MessageID = <header>-msgid ) TO failed-header.

        LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ret>) WHERE type CA 'EAX'.
          APPEND VALUE #(
            MessageID = <header>-msgid
            %msg = new_message_with_text(
                     text     = <ret>-message
                     severity = if_abap_behv_message=>severity-error )
          ) TO reported-header.
        ENDLOOP.

      ENDIF.

      TYPES: BEGIN OF ty_log_ser,
               SerialNumber     TYPE gernr,
               UniqueIdentifier TYPE char72,
             END OF ty_log_ser,
             BEGIN OF ty_log_itm,
               Item                 TYPE numc4,
               Material             TYPE char40,
               Plant                TYPE char4,
               StorageLocation      TYPE char4,
               MovementType         TYPE char3,
               StockType            TYPE char1,
               Quantity             TYPE erfmg,
               UOM                  TYPE erfme,
               ReservationNumber    TYPE char10,
               ReservationItemNo    TYPE numc4,
               MaterialDocumentItem TYPE numc4,
               _Serials             TYPE STANDARD TABLE OF ty_log_ser WITH EMPTY KEY,
             END OF ty_log_itm,
             BEGIN OF ty_log_hdr,
               PartnerName          TYPE char50,
               PartnerMessageID     TYPE char50,
               GoodsMovementCode    TYPE char2,
               PostingDate          TYPE dats,
               DocumentDate         TYPE dats,
               ReferenceDocument    TYPE char16,
               HeaderText           TYPE char25,
               _Items               TYPE STANDARD TABLE OF ty_log_itm WITH EMPTY KEY,
             END OF ty_log_hdr.

      DATA ls_log     TYPE ty_log_hdr.
      DATA ls_log_itm TYPE ty_log_itm.

      ls_log-PartnerName       = <header>-partner.
      ls_log-PartnerMessageID  = <header>-partner_msgid.
      ls_log-GoodsMovementCode = <header>-gm_code.
      ls_log-PostingDate       = <header>-pstng_date.
      ls_log-DocumentDate      = <header>-doc_date.
      ls_log-ReferenceDocument = <header>-ref_doc_no.
      ls_log-HeaderText        = <header>-header_txt.

      LOOP AT lcl_buffer=>gt_item INTO DATA(ls_buf_itm)
        WHERE msgid = <header>-msgid.
        CLEAR ls_log_itm.
        ls_log_itm-Item                 = ls_buf_itm-item_no.
        ls_log_itm-Material             = ls_buf_itm-material_long.
        ls_log_itm-Plant                = ls_buf_itm-plant.
        ls_log_itm-StorageLocation      = ls_buf_itm-stge_loc.
        ls_log_itm-MovementType         = ls_buf_itm-move_type.
        ls_log_itm-StockType            = ls_buf_itm-stck_type.
        ls_log_itm-Quantity             = ls_buf_itm-entry_qnt.
        ls_log_itm-UOM                  = ls_buf_itm-entry_uom.
        ls_log_itm-ReservationNumber    = ls_buf_itm-reserv_no.
        ls_log_itm-ReservationItemNo    = ls_buf_itm-res_item.
        ls_log_itm-MaterialDocumentItem = ls_buf_itm-matdoc_itm.

        LOOP AT lcl_buffer=>gt_serial INTO DATA(ls_buf_ser)
          WHERE msgid   = <header>-msgid
            AND item_no = ls_buf_itm-item_no.
          APPEND VALUE ty_log_ser(
            SerialNumber     = ls_buf_ser-serialno
            UniqueIdentifier = ls_buf_ser-uii
          ) TO ls_log_itm-_Serials.
        ENDLOOP.

        APPEND ls_log_itm TO ls_log-_Items.
      ENDLOOP.

      DATA(lv_json) = /ui2/cl_json=>serialize(
        data        = ls_log
        compress    = abap_true
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

      TRY.
          CALL FUNCTION 'ZCAFM_INSERT_IF_LOG'
            STARTING NEW TASK 'ZAPI_LOG'
            EXPORTING
              iv_interface_id = 'MM-I-005'
              iv_status       = COND #( WHEN lv_failed = abap_true
                                        THEN zcacl_if_log=>c_status-error
                                        ELSE zcacl_if_log=>c_status-success )
              iv_message      = COND #( WHEN lv_failed = abap_true
                                        THEN 'Material document creation failed'
                                        ELSE |Material document { lv_matdoc } created| )
              iv_json_payload = lv_json
              iv_format_json  = abap_true
            TABLES
              it_return       = lt_return.
        CATCH cx_root ##CATCH_ALL ##NO_HANDLER.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD save.

    LOOP AT lcl_buffer=>gt_header ASSIGNING FIELD-SYMBOL(<header>).

      READ TABLE lcl_buffer=>gt_results INTO DATA(ls_result)
        WITH KEY msgid = <header>-msgid.
      IF sy-subrc = 0.
        <header>-mat_doc      = ls_result-mat_doc.
        <header>-mat_doc_year = ls_result-mat_doc_year.

        INSERT zmmt_gmvt_h FROM <header>.
        INSERT zmmt_gmvt_i FROM TABLE
          @( VALUE #( FOR ls_i IN lcl_buffer=>gt_item
                      WHERE ( msgid = <header>-msgid ) ( ls_i ) ) ).
        INSERT zmmt_gmvt_s FROM TABLE
          @( VALUE #( FOR ls_s IN lcl_buffer=>gt_serial
                      WHERE ( msgid = <header>-msgid ) ( ls_s ) ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD cleanup_finalize.
    lcl_buffer=>clear( ).
  ENDMETHOD.

ENDCLASS.
