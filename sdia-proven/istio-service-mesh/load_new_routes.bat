@echo off
echo Loading HR + Manufacturing routes into Redis KVM...

kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/hr/employees/sync/successfactors" "gdcremployeessSFid31:http"
kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/hr/payroll/create/adp" "gdcrpayrollcAdpid32:http"
kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/hr/benefits/sync/workday" "gdcrbeneficessWorkdayid33:http"
kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/hr/timesheets/update/kronos" "gdcrtimesheetsuKronosid34:http"
kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/manufacturing/equipment/read/siemens" "gdcrequipmentrSiemensid41:http"
kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/manufacturing/alerts/notify/sap" "gdcralertsnSapid42:http"
kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/manufacturing/orders/create/s4hana" "gdcrorderscS4hanaid43:http"

echo Done!
kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli DBSIZE
