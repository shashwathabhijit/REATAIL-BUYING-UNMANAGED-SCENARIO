CLASS zcit_utl_22cs157 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " Define the table types using your actual database tables
    TYPES: tt_hdr TYPE STANDARD TABLE OF zbill_hdr_157 WITH DEFAULT KEY,
           tt_itm TYPE STANDARD TABLE OF zbill_itm_157 WITH DEFAULT KEY,
           tt_del_hdr TYPE STANDARD TABLE OF zbill_hdr_157 WITH DEFAULT KEY,
           tt_del_itm TYPE STANDARD TABLE OF zbill_itm_157 WITH DEFAULT KEY.

    " Singleton instance getter
    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcit_utl_22cs157.

    " Methods to write to the buffer
    METHODS buffer_hdr IMPORTING is_hdr TYPE zbill_hdr_157.
    METHODS buffer_itm IMPORTING is_itm TYPE zbill_itm_157.
    METHODS buffer_del_hdr IMPORTING iv_uuid TYPE sysuuid_x16.
    METHODS buffer_del_itm IMPORTING iv_uuid TYPE sysuuid_x16.

    " Methods to read from the buffer
    METHODS get_buffered_hdr RETURNING VALUE(rt_hdr) TYPE tt_hdr.
    METHODS get_buffered_itm RETURNING VALUE(rt_itm) TYPE tt_itm.
    METHODS get_del_hdr RETURNING VALUE(rt_del_hdr) TYPE tt_del_hdr.
    METHODS get_del_itm RETURNING VALUE(rt_del_itm) TYPE tt_del_itm.

    METHODS clear_buffer.

  PRIVATE SECTION.
    CLASS-DATA mo_instance TYPE REF TO zcit_utl_22cs157.
    DATA: mt_hdr TYPE tt_hdr, mt_itm TYPE tt_itm,
          mt_del_hdr TYPE tt_del_hdr, mt_del_itm TYPE tt_del_itm.
ENDCLASS.

CLASS zcit_utl_22cs157 IMPLEMENTATION.

  METHOD get_instance.
    IF mo_instance IS INITIAL.
      mo_instance = NEW #( ).
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD buffer_hdr.
    APPEND is_hdr TO mt_hdr.
  ENDMETHOD.

  METHOD buffer_itm.
    APPEND is_itm TO mt_itm.
  ENDMETHOD.

  METHOD buffer_del_hdr.
    APPEND VALUE #( bill_uuid = iv_uuid ) TO mt_del_hdr.
  ENDMETHOD.

  METHOD buffer_del_itm.
    APPEND VALUE #( itemuuid = iv_uuid ) TO mt_del_itm.
  ENDMETHOD.

  METHOD get_buffered_hdr.
    rt_hdr = mt_hdr.
  ENDMETHOD.

  METHOD get_buffered_itm.
    rt_itm = mt_itm.
  ENDMETHOD.

  METHOD get_del_hdr.
    rt_del_hdr = mt_del_hdr.
  ENDMETHOD.

  METHOD get_del_itm.
    rt_del_itm = mt_del_itm.
  ENDMETHOD.

  METHOD clear_buffer.
    CLEAR: mt_hdr, mt_itm, mt_del_hdr, mt_del_itm.
  ENDMETHOD.

ENDCLASS.
