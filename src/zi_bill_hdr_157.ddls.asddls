@EndUserText.label: 'Root View for Bill Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_BILL_HDR_157
  as select from zbill_hdr_157 as Header
  composition [0..*] of ZI_BILL_ITM_157 as _BillItems
{
  key bill_uuid as BillUuid,
  bill_number as BillNumber,
  customer_name as CustomerName,
  billing_date as BillingDate,
  @Semantics.amount.currencyCode: 'Currency'
  total_amount as TotalAmount,
  currency as Currency,
 payment_status as PaymentStatus,
  local_last_changed_at as LocalLastChangedAt,
  last_changed_at as LastChangedAt,

  _BillItems
}
