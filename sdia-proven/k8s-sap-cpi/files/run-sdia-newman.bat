@echo off
echo ============================================================
echo  SDIA GDCR — Newman Test Runner
echo  Ricardo Luz Holanda Viana ^| March 2026
echo ============================================================

:: ---- DEPLOY v2.2 ----
echo.
echo [1/4] Deploying handler v2.2...
kubectl delete configmap gdcr-plugin -n sdia >nul 2>&1
kubectl apply -f 02-kong-gdcr.yaml
kubectl rollout restart deployment/kong -n sdia
kubectl rollout status deployment/kong -n sdia
echo.

:: ---- SMOKE TEST — 42 routes ----
echo [2/4] Running smoke test — 42 routes...
newman run sdia-smoke-collection.json ^
  --env-var "base_url=http://localhost:30800" ^
  --reporters cli ^
  --reporter-cli-no-banner ^
  --delay-request 200
echo.

:: ---- LOAD TEST — 100k requests ----
echo [3/4] Running load test — 100k iterations...
newman run sdia-smoke-collection.json ^
  --env-var "base_url=http://localhost:30800" ^
  --iteration-count 2381 ^
  --delay-request 0 ^
  --reporters cli,json ^
  --reporter-json-export sdia-newman-100k-results.json ^
  --reporter-cli-no-banner
echo.

:: ---- RESULTS ----
echo [4/4] Done! Results saved to sdia-newman-100k-results.json
echo ============================================================
pause
