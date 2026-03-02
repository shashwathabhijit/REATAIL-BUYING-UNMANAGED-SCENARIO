@EndUserText.label: 'Child View for Bill Items'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_BILL_ITM_157
  as select from zbill_itm_157 as Item
  association to parent ZI_BILL_HDR_157 as _BillHeader
    on $projection.BillUuid = _BillHeader.BillUuid
{
  key item_uuid as ItemUuid,
  bill_uuid as BillUuid,
  item_position as ItemPosition,
  product_id as ProductId,
  @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
  quantity as Quantity,
  quantityunit as QuantityUnit,
  @Semantics.amount.currencyCode: 'Currency'
  unit_price as UnitPrice,
  @Semantics.amount.currencyCode: 'Currency'
  subtotal as Subtotal,
  currency as Currency,
  local_last_changed_at as LocalLastChangedAt,

  _BillHeader
}
