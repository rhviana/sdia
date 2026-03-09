@echo off
echo ========================================
echo SDIA Smoke Test — 42 Endpoints CPI Real
echo ========================================
echo.

set BASE=http://localhost:30800
set PASS=0
set FAIL=0

call :test "/sales/orders/create/salesforce"
call :test "/sales/orders/update/salesforceemea"
call :test "/sales/payments/notify/stripe"
call :test "/sales/customers/sync/shopify"
call :test "/sales/invoices/create/quickbooks"
call :test "/sales/deliveries/transfer/fedex"
call :test "/sales/returns/create/shopify"
call :test "/sales/orders/create/microsoft"
call :test "/sales/payments/notify/s4hana"
call :test "/sales/customers/sync/s4hana"
call :test "/sales/invoices/create/s4hana"
call :test "/sales/deliveries/transfer/s4hana"
call :test "/sales/returns/create/s4hana"
call :test "/finances/taxes/create/avalara"
call :test "/finances/budgets/sync/workday"
call :test "/finances/invoices/create/quickbooks"
call :test "/finances/expenses/create/coupa"
call :test "/finances/payments/notify/stripe"
call :test "/finances/payments/notify/s4hana"
call :test "/finances/invoices/create/s4hana"
call :test "/finances/journals/create/sap"
call :test "/finances/accounts/sync/xero"
call :test "/finances/receipts/update/concur"
call :test "/procurement/requisitions/create/ariba"
call :test "/procurement/pos/create/coupa"
call :test "/procurement/rfqs/create/ariba"
call :test "/procurement/invoices/approve/basware"
call :test "/procurement/suppliers/sync/ivalua"
call :test "/procurement/catalogs/update/tradeshift"
call :test "/procurement/grns/create/wms"
call :test "/procurement/buyers/sync/oracle"
call :test "/procurement/sourcings/query/ariba"
call :test "/procurement/contracts/sync/jaggaer"
call :test "/logistics/shipments/create/fedex"
call :test "/logistics/trackings/update/ups"
call :test "/logistics/deliveries/create/dhl"
call :test "/logistics/shipments/query/fedex"
call :test "/logistics/containers/sync/maersk"
call :test "/logistics/warehouses/update/sf"
call :test "/logistics/freights/create/coyote"
call :test "/logistics/routes/sync/project44"
call :test "/logistics/manifests/create/customs"

echo.
echo ========================================
echo RESULTS: %PASS% PASS / %FAIL% FAIL
echo ========================================
goto :eof

:test
set ENDPOINT=%~1
curl -s -o tmp_response.txt -w "%%{http_code}" -X POST %BASE%%ENDPOINT% > tmp_code.txt
set /p HTTP_CODE=<tmp_code.txt
set /p RESPONSE=<tmp_response.txt
if "%HTTP_CODE%"=="200" (
    echo [PASS] %ENDPOINT%
    set /a PASS+=1
) else (
    echo [FAIL] %ENDPOINT% — HTTP %HTTP_CODE%
    echo        %RESPONSE%
    set /a FAIL+=1
)
goto :eof
