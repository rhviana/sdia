#!/bin/bash
# =============================================================
# SDIA K8s — Step 3: Load KVM Routes + Test
# Ricardo Luz Holanda Viana | March 2026
# =============================================================

echo "=============================================="
echo "  SDIA K8s — Loading KVM Routes into Redis"
echo "=============================================="

# Wait for Redis pod
echo "[1/4] Waiting for Redis pod..."
kubectl wait --namespace sdia \
  --for=condition=ready pod \
  --selector=app=redis \
  --timeout=60s

# Get Redis pod name
REDIS_POD=$(kubectl get pod -n sdia -l app=redis -o jsonpath="{.items[0].metadata.name}")
echo "[2/4] Redis pod: $REDIS_POD"

# Load SDIA routes into Redis KVM
echo "[3/4] Loading semantic routes into Redis KVM..."
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/sales/orders/create/salesforce"    "gdcrorderscsalesforceid01:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/sales/orders/read/s4hana"          "gdcrordersr s4hanaid02:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/sales/customers/sync/s4hana"       "gdcrcustomersss4hanaid07:cxf"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/sales/invoices/create/s4hana"      "gdcrinvoicescS4hanaid03:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/finance/payments/transfer/stripe"  "gdcrpaymentstStripeid11:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/finance/invoices/read/s4hana"      "gdcrinvoicesrS4hanaid12:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/procurement/orders/create/ariba"   "gdcrorderscAribaid21:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/hr/employees/sync/successfactors"  "gdcremployeessSFid31:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/logistics/shipments/track/fedex"   "gdcrshipmentstFedexid41:http"
kubectl exec -n sdia $REDIS_POD -- redis-cli SET "/marketing/campaigns/create/sfmc"   "gdcrcampaignscSFMCid51:http"

echo "[4/4] Routes loaded!"
echo ""
echo "Verifying KVM:"
kubectl exec -n sdia $REDIS_POD -- redis-cli KEYS "*"

echo ""
echo "=============================================="
echo "  SDIA K8s — Test Semantic Routing"
echo "=============================================="
echo ""
echo "Testing: POST /sales/orders/create/salesforce"
curl -s -X POST http://localhost:30800/sales/orders/create/salesforce | python3 -m json.tool

echo ""
echo "Testing: POST /finance/payments/transfer/stripe"
curl -s -X POST http://localhost:30800/finance/payments/transfer/stripe | python3 -m json.tool

echo ""
echo "Testing: Fast Fail — invalid route"
curl -s -X POST http://localhost:30800/unknown/entity/action/target | python3 -m json.tool

echo ""
echo "=============================================="
echo "  SDIA K8s Validation Complete"
echo "  The domain never lies."
echo "=============================================="
