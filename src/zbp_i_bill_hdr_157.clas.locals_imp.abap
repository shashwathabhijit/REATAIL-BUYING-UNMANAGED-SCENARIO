*CLASS lhc_BillHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR BillHeader RESULT result.
*
*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE BillHeader.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE BillHeader.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE BillHeader.
*
*    METHODS read FOR READ
*      IMPORTING keys FOR READ BillHeader RESULT result.
*
*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK BillHeader.
*
*    METHODS rba_Billitems FOR READ
*      IMPORTING keys_rba FOR READ BillHeader\_Billitems FULL result_requested RESULT result LINK association_links.
*
*    METHODS cba_Billitems FOR MODIFY
*      IMPORTING entities_cba FOR CREATE BillHeader\_Billitems.
*
*ENDCLASS.
*
*CLASS lhc_BillHeader IMPLEMENTATION.
*
*  METHOD get_instance_authorizations.
*  ENDMETHOD.
*
*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.
*
*  METHOD read.
*  ENDMETHOD.
*
*  METHOD lock.
*  ENDMETHOD.
*
*  METHOD rba_Billitems.
*  ENDMETHOD.
*
*  METHOD cba_Billitems.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lhc_BillItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE BillItem.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE BillItem.
*
*    METHODS read FOR READ
*      IMPORTING keys FOR READ BillItem RESULT result.
*
*    METHODS rba_Billheader FOR READ
*      IMPORTING keys_rba FOR READ BillItem\_Billheader FULL result_requested RESULT result LINK association_links.
*
*ENDCLASS.
*
*CLASS lhc_BillItem IMPLEMENTATION.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.
*
*  METHOD read.
*  ENDMETHOD.
*
*  METHOD rba_Billheader.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lsc_ZI_BILL_HDR_157 DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.
*
*    METHODS finalize REDEFINITION.
*
*    METHODS check_before_save REDEFINITION.
*
*    METHODS save REDEFINITION.
*
*    METHODS cleanup REDEFINITION.
*
*    METHODS cleanup_finalize REDEFINITION.
*
*ENDCLASS.
*
*CLASS lsc_ZI_BILL_HDR_157 IMPLEMENTATION.
*
*  METHOD finalize.
*  ENDMETHOD.
*
*  METHOD check_before_save.
*  ENDMETHOD.
*
*  METHOD save.
*  ENDMETHOD.
*
*  METHOD cleanup.
*  ENDMETHOD.
*
*  METHOD cleanup_finalize.
*  ENDMETHOD.
*
*ENDCLASS.
CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR BillHeader RESULT result.

    METHODS create FOR MODIFY IMPORTING entities FOR CREATE BillHeader.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE BillHeader.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE BillHeader.

    METHODS cba_Billitems FOR MODIFY IMPORTING entities_cba FOR CREATE BillHeader\_BillItems.

    METHODS MarkAsPaid FOR MODIFY IMPORTING keys FOR ACTION BillHeader~MarkAsPaid RESULT result.
    METHODS lock FOR LOCK IMPORTING keys FOR LOCK BillHeader.
    METHODS read FOR READ IMPORTING keys FOR READ BillHeader RESULT result.
ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    LOOP AT entities INTO DATA(ls_entity).
       DATA(ls_hdr) = CORRESPONDING ZBILL_HDR_157( ls_entity MAPPING FROM ENTITY ).
       ls_hdr-bill_uuid = ls_entity-BillUuid.

       zcit_utl_22cs157=>get_instance( )->buffer_hdr( ls_hdr ).
       INSERT VALUE #( %cid = ls_entity-%cid BillUuid = ls_hdr-bill_uuid ) INTO TABLE mapped-billheader.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA ls_hdr TYPE ZBILL_HDR_157.
    LOOP AT entities INTO DATA(ls_entity).
      SELECT SINGLE * FROM ZBILL_HDR_157 WHERE bill_uuid = @ls_entity-BillUuid INTO @ls_hdr.
      IF ls_entity-%control-CustomerName = if_abap_behv=>mk-on. ls_hdr-customer_name = ls_entity-CustomerName. ENDIF.
      IF ls_entity-%control-PaymentStatus = if_abap_behv=>mk-on. ls_hdr-payment_status = ls_entity-PaymentStatus. ENDIF.

      " FIXED: Changed zutil_22ad119 to zcit_utl_22cs157
      zcit_utl_22cs157=>get_instance( )->buffer_hdr( ls_hdr ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      zcit_utl_22cs157=>get_instance( )->buffer_del_hdr( ls_key-BillUuid ).
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Billitems.
    DATA ls_itm TYPE ZBILL_ITM_157.
    LOOP AT entities_cba INTO DATA(ls_cba_entity).
      LOOP AT ls_cba_entity-%target INTO DATA(ls_target).
        ls_itm = CORRESPONDING #( ls_target MAPPING FROM ENTITY ).
        ls_itm-item_uuid = ls_target-ItemUuid.
        ls_itm-bill_uuid = ls_cba_entity-BillUuid.

        zcit_utl_22cs157=>get_instance( )->buffer_itm( ls_itm ).
        INSERT VALUE #( %cid = ls_target-%cid ItemUuid = ls_itm-item_uuid ) INTO TABLE mapped-billitem.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD MarkAsPaid.
    DATA ls_hdr TYPE ZBILL_HDR_157.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM ZBILL_HDR_157 WHERE bill_uuid = @ls_key-BillUuid INTO @ls_hdr.
      ls_hdr-payment_status = 'Paid'.
      zcit_utl_22cs157=>get_instance( )->buffer_hdr( ls_hdr ).
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE bill_uuid FROM ZBILL_HDR_157
        WHERE bill_uuid = @ls_key-BillUuid
        INTO @DATA(lv_dummy).

      IF sy-subrc <> 0.
        APPEND VALUE #( BillUuid = ls_key-BillUuid ) TO failed-billheader.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM ZBILL_HDR_157 WHERE bill_uuid = @ls_key-BillUuid INTO @DATA(ls_db).
      IF sy-subrc = 0.
        INSERT CORRESPONDING #( ls_db ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE BillItem.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE BillItem.
    METHODS read FOR READ IMPORTING keys FOR READ BillItem RESULT result.
ENDCLASS.

CLASS lhc_item IMPLEMENTATION.
  METHOD update.
    DATA ls_itm TYPE ZBILL_ITM_157.
    LOOP AT entities INTO DATA(ls_entity).
      SELECT SINGLE * FROM ZBILL_ITM_157 WHERE item_uuid = @ls_entity-ItemUuid INTO @ls_itm.
      IF ls_entity-%control-Quantity = if_abap_behv=>mk-on. ls_itm-quantity = ls_entity-Quantity. ENDIF.
      IF ls_entity-%control-UnitPrice = if_abap_behv=>mk-on. ls_itm-unit_price = ls_entity-UnitPrice. ENDIF.
      zcit_utl_22cs157=>get_instance( )->buffer_itm( ls_itm ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      zcit_utl_22cs157=>get_instance( )->buffer_del_itm( ls_key-ItemUuid ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM ZBILL_ITM_157 WHERE item_uuid = @ls_key-ItemUuid INTO @DATA(ls_db).
      IF sy-subrc = 0.
        INSERT CORRESPONDING #( ls_db ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

" FIXED: Renamed Saver class to match your current project
CLASS lsc_zbp_i_bill_hdr_157 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
ENDCLASS.

CLASS lsc_zbp_i_bill_hdr_157 IMPLEMENTATION.
  METHOD save.
    DATA(lt_hdr) = zcit_utl_22cs157=>get_instance( )->get_buffered_hdr( ).
    IF lt_hdr IS NOT INITIAL. MODIFY ZBILL_HDR_157 FROM TABLE @lt_hdr. ENDIF.

    DATA(lt_itm) = zcit_utl_22cs157=>get_instance( )->get_buffered_itm( ).
    IF lt_itm IS NOT INITIAL. MODIFY ZBILL_ITM_157 FROM TABLE @lt_itm. ENDIF.

    DATA(lt_del_hdr) = zcit_utl_22cs157=>get_instance( )->get_del_hdr( ).
    IF lt_del_hdr IS NOT INITIAL.
      LOOP AT lt_del_hdr INTO DATA(ls_del_hdr).
        DELETE FROM ZBILL_HDR_157 WHERE bill_uuid = @ls_del_hdr-bill_uuid.
        DELETE FROM ZBILL_ITM_157 WHERE bill_uuid = @ls_del_hdr-bill_uuid.
      ENDLOOP.
    ENDIF.

    DATA(lt_del_itm) = zcit_utl_22cs157=>get_instance( )->get_del_itm( ).
    IF lt_del_itm IS NOT INITIAL.
      LOOP AT lt_del_itm INTO DATA(ls_del_itm).
        DELETE FROM ZBILL_ITM_157 WHERE item_uuid = @ls_del_itm-item_uuid.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zcit_utl_22cs157=>get_instance( )->clear_buffer( ).
  ENDMETHOD.
ENDCLASS.
