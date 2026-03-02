@EndUserText.label: 'Projection View for Bill Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_BHDR_22CS157
  provider contract transactional_query
  as projection on ZI_BILL_HDR_157
{
  key BillUuid,
      BillNumber,
      CustomerName,
      BillingDate,
      TotalAmount,
      Currency,
      PaymentStatus,
      LocalLastChangedAt,

      /* Associations */
      _BillItems : redirected to composition child ZC_BITM_22CS157
}
