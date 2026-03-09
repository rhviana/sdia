@echo off
echo Loading all routes into Redis KVM...
echo Pod: redis-794bb58794-zqhjk

:: SALES (13 routes)
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/orders/create/salesforce"     "gdcrorderscSalesforceid01:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/orders/update/salesforceemea" "gdcrordersuSalesforceid02:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/orders/create/microsoft"      "gdcrorderscMicrosoftid05:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/invoices/create/quickbooks"   "gdcrinvoicescQuickbooksid09:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/invoices/create/s4hana"       "gdcrinvoicescS4hanaid10:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/payments/notify/stripe"       "gdcrpaymentsnStripeid04:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/payments/notify/s4hana"       "gdcrpaymentsnS4hanaid08:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/customers/sync/shopify"       "gdcrcustomerssShopifyid03:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/customers/sync/s4hana"        "gdcrcustomerssS4hanaid07:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/deliveries/transfer/fedex"    "gdcrdeliveriestFedexid06:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/deliveries/transfer/s4hana"   "gdcrdeliveriestS4hanaid11:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/returns/create/shopify"       "gdcrreturnscShopifyid12:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/sales/returns/create/s4hana"        "gdcrreturnscS4hanaid13:soap"

:: FINANCES (10 routes)
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/invoices/create/quickbooks" "gdcrinvoicescQuickbooksid01:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/invoices/create/s4hana"     "gdcrinvoicescS4hanaid02:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/taxes/create/avalara"       "gdcrtaxescAvalaraid10:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/budgets/sync/workday"       "gdcrbudgetssWorkdayid09:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/expenses/create/coupa"      "gdcrexpensescCoupaid07:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/payments/notify/stripe"     "gdcrpaymentsnStripeid03:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/payments/notify/s4hana"     "gdcrpaymentsnS4hanaid04:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/journals/create/sap"        "gdcrjournalscSapid06:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/accounts/sync/xero"         "gdcraccountssXeroid05:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/finances/receipts/update/concur"     "gdcrreceiptsuConcurid08:http"

:: PROCUREMENT (10 routes)
:: FIX: pos/create/coupa → http (era soap)
:: FIX: rfqs/create/ariba → soap (era http)
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/requisitions/create/ariba"  "gdcrrequisitionscAribaid01:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/pos/create/coupa"           "gdcrposcCoupaid02:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/rfqs/create/ariba"          "gdcrrfqscAribaid03:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/invoices/approve/basware"   "gdcrinvoicesaBaswareid05:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/contracts/sync/jaggaer"     "gdcrcontractssJaggaerid04:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/suppliers/sync/ivalua"      "gdcrsupplierssIvaluaid06:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/catalogs/update/tradeshift" "gdcrcatalogsuTradeshiftid07:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/grns/create/wms"            "gdcrgrsnscWmsid08:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/buyers/sync/oracle"         "gdcrbuyerssOracleid09:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/procurement/sourcings/query/ariba"      "gdcrsourcingsqAribaid10:soap"

:: LOGISTICS (9 routes)
:: FIX: manifests/create/customs → resource "manifest" no CPI (sem s)
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/shipments/create/fedex"    "gdcrshipmentscFedexid01:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/trackings/update/ups"      "gdcrtrackingsuUpsid02:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/deliveries/create/dhl"     "gdcrdeliveriescDhlid03:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/shipments/query/fedex"     "gdcrshipmentsqFedexid04:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/containers/sync/maersk"    "gdcrcontainerssMarskid05:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/warehouses/update/sf"      "gdcrwarehousesuSfid06:soap"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/freights/create/coyote"    "gdcrfreightscCoyoteid07:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/routes/sync/project44"     "gdcrroutessProject44id08:http"
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli SET "/logistics/manifests/create/customs"  "gdcrmanifestscCustomsid09:soap"

echo.
echo Done!
kubectl exec -n sdia redis-794bb58794-zqhjk -- redis-cli DBSIZE
