@EndUserText.label: 'Projection View for Bill Items'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_BITM_22CS157
  as projection on ZI_BILL_ITM_157
{
  key ItemUuid,
      BillUuid,
      ItemPosition,
      ProductId,
      Quantity,
      QuantityUnit,
      UnitPrice,
      Subtotal,
      Currency,
      LocalLastChangedAt,

      /* Associations */
      _BillHeader : redirected to parent ZC_BHDR_22CS157
}
