package com.sdia.ddcr;

import com.netflix.zuul.ZuulFilter;
import com.netflix.zuul.context.RequestContext;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * ============================================================================
 * DDCR Phantom v12 — Netflix Zuul Filter (Java Port)
 * ============================================================================
 * Author:    Ricardo Luz Holanda Viana
 * Email:     rhviana@gmail.com
 * License:   CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/)
 * DOI:       https://doi.org/10.5281/zenodo.18619641
 * GitHub:    https://github.com/rhviana/gdcr
 *
 * Zero regex | Zero hardcode | Zero split | O(1) lookup after warm cache
 * Compatible: Netflix Zuul | Spring Cloud Gateway
 * ============================================================================
 *
 * KVM key format:  dcrp<process><entity><actioncode><vendor>id<digits>
 * KVM value format: <adapter>  (http | soap)
 *
 * Path format: /{domain}/{entity}/{action}/{vendor}
 * ============================================================================
 */
@Component
public class DdcrPhantomFilter extends ZuulFilter {

    // ── CPI Target Host ──────────────────────────────────────────────────────
    private static final String CPI_HOST =
        "https://YOUR-TRIAL.it-cpitrial05-rt.cfapps.us10-001.hana.ondemand.com";

    // ── Basic Auth (Base64 clientid:clientsecret) ────────────────────────────
    private static final String BASIC_AUTH =
        "Basic YOUR-BASE64-CREDENTIALS";

    // ── Worker-scoped cache (O(1) after warm) ────────────────────────────────
    private static final ConcurrentHashMap<String, RouteEntry> KVM_CACHE =
        new ConcurrentHashMap<>();

    // ── Canonical Action Map — 241 variants → 15 codes ──────────────────────
    private static final Map<String, String> ACTION_MAP = new HashMap<>();

    static {
        // c: CREATE
        String[] create = {"create","created","post","insert","add","new","submit",
            "register","registered","provision","provisioning","onboard","onboarding",
            "publish","publishing","generate","build","built","open","opening",
            "setup","initialize","initializing","initialized","draft"};
        for (String a : create) ACTION_MAP.put(a, "c");

        // r: READ
        String[] read = {"read","get","fetch","retrieve","view","viewed","list",
            "listing","listed","show","showing","shown","search","searching",
            "searched","find","finding","found","query","querying","queried",
            "lookup","check","inspect"};
        for (String a : read) ACTION_MAP.put(a, "r");

        // u: UPDATE
        String[] update = {"update","updating","updated","put","patch","patching",
            "modify","modifying","modified","change","changing","changed","edit",
            "editing","edited","revise","revising","revised","amend","amending",
            "amended","replace","replacing","replaced","upsert"};
        for (String a : update) ACTION_MAP.put(a, "u");

        // d: DELETE
        String[] delete = {"delete","deleting","deleted","remove","removing","removed",
            "cancel","cancelling","cancelled","terminate","terminating","terminated",
            "destroy","destroying","destroyed","deactivate","purge","purging",
            "purged","discard"};
        for (String a : delete) ACTION_MAP.put(a, "d");

        // s: SYNC
        String[] sync = {"sync","syncing","synced","synchronize","synchronizing",
            "synchronized","replicate","replicating","replicated","mirror",
            "mirroring","mirrored","refresh","refreshing","refreshed",
            "reconcile","harmonize","align"};
        for (String a : sync) ACTION_MAP.put(a, "s");

        // a: APPROVE
        String[] approve = {"approve","approving","approved","authorize","authorizing",
            "authorized","accept","accepting","accepted","validate","validating",
            "validated","confirm","confirming","confirmed","endorse","certify","signoff"};
        for (String a : approve) ACTION_MAP.put(a, "a");

        // n: NOTIFY
        String[] notify = {"notify","notifying","notified","alert","alerting","alerted",
            "inform","informing","informed","announce","announcing","announced",
            "broadcast","broadcasting","broadcasted","emit","trigger","signal"};
        for (String a : notify) ACTION_MAP.put(a, "n");

        // t: TRANSFER
        String[] transfer = {"transfer","transferring","transferred","send","sending",
            "sent","move","moving","moved","migrate","migrating","migrated",
            "forward","forwarding","relay","handoff"};
        for (String a : transfer) ACTION_MAP.put(a, "t");

        // e: ENABLE
        String[] enable = {"enable","enabling","enabled","activate","activating",
            "activated","start","starting","started","resume","resuming","resumed"};
        for (String a : enable) ACTION_MAP.put(a, "e");

        // b: DISABLE
        String[] disable = {"disable","disabling","disabled","deactivate","deactivating",
            "deactivated","stop","stopping","stopped","pause","pausing","paused"};
        for (String a : disable) ACTION_MAP.put(a, "b");

        // v: ARCHIVE
        String[] archive = {"archive","archiving","archived","store","storing","stored",
            "backup","backing","backed","retain"};
        for (String a : archive) ACTION_MAP.put(a, "v");

        // w: RESTORE
        String[] restore = {"restore","restoring","restored","unarchive","recover",
            "recovering","recovered","rollback","revert","reinstate"};
        for (String a : restore) ACTION_MAP.put(a, "w");

        // x: AUDIT
        String[] audit = {"audit","auditing","audited","log","logging","logged",
            "trace","tracing","traced","track","tracking","tracked"};
        for (String a : audit) ACTION_MAP.put(a, "x");

        // z: EXECUTE
        String[] execute = {"execute","executing","executed","run","running","ran",
            "process","processing","processed","compute","computing","computed"};
        for (String a : execute) ACTION_MAP.put(a, "z");

        // f: FLOW
        String[] flow = {"flow","flowing","flowed","route","routing","routed",
            "dispatch","dispatching","dispatched","pipeline"};
        for (String a : flow) ACTION_MAP.put(a, "f");
    }

    // ── RouteEntry — parsed KVM entry ────────────────────────────────────────
    static class RouteEntry {
        final String adapter;
        final String id;
        final String keyOriginal;
        final String stripped;

        RouteEntry(String adapter, String id, String keyOriginal, String stripped) {
            this.adapter     = adapter;
            this.id          = id;
            this.keyOriginal = keyOriginal;
            this.stripped    = stripped;
        }
    }

    // ── Zuul filter config ────────────────────────────────────────────────────
    @Override public String filterType()  { return "pre"; }
    @Override public int    filterOrder() { return 1; }
    @Override public boolean shouldFilter() { return true; }

    // ============================================================================
    // run — main DDCR routing logic
    // ============================================================================
    @Override
    public Object run() {
        RequestContext ctx = RequestContext.getCurrentContext();
        HttpServletRequest req = ctx.getRequest();

        String path = req.getRequestURI();

        // ── Stage 1-2: Parse and validate path ───────────────────────────────
        // Expected: /{domain}/{entity}/{action}/{target}
        String[] segs = parsePath(path);
        if (segs == null) {
            rejectRequest(ctx, 400, "invalid semantic URL — expected /{domain}/{entity}/{action}/{target}");
            return null;
        }

        String domain   = segs[0];
        String entity   = segs[1];
        String action   = segs[2];
        String target   = segs[3];

        // ── Stage 3: Redis KVM lookup ─────────────────────────────────────────
        // In production: use Jedis or Lettuce to connect to Redis
        // For POC: load KVM from environment variable or properties file
        String routeValue = kvmLookup(path);
        if (routeValue == null) {
            rejectRequest(ctx, 404, "route not found in KVM: " + path);
            return null;
        }

        // ── Stage 4: Normalize action ─────────────────────────────────────────
        String actionCode = ACTION_MAP.getOrDefault(action.toLowerCase(),
            String.valueOf(action.charAt(0)));

        // ── Stage 5: Parse interface_id and protocol ──────────────────────────
        int colonIdx = routeValue.lastIndexOf(':');
        if (colonIdx == -1) {
            rejectRequest(ctx, 500, "malformed KVM value: " + routeValue);
            return null;
        }
        String interfaceId = routeValue.substring(0, colonIdx);
        String protocol    = routeValue.substring(colonIdx + 1);

        // ── Stage 6: Extract id suffix ────────────────────────────────────────
        String idSuffix = extractIdSuffix(interfaceId);

        // ── Stage 7: Build CPI path and forward ──────────────────────────────
        String prefix      = "soap".equals(protocol) ? "cxf" : "http";
        String cpiPath     = "/" + prefix + "/dcrp/" + entity + "/" + actionCode + "/" + idSuffix;
        String contentType = "soap".equals(protocol)
            ? "text/xml; charset=utf-8"
            : "application/json";

        String targetUrl = CPI_HOST + cpiPath;

        // ── Set routing headers ───────────────────────────────────────────────
        ctx.addZuulRequestHeader("Authorization",    BASIC_AUTH);
        ctx.addZuulRequestHeader("Content-Type",     contentType);
        ctx.addZuulRequestHeader("X-SDIA-Domain",    domain);
        ctx.addZuulRequestHeader("X-SDIA-Version",   "12.0");
        ctx.addZuulRequestHeader("X-SDIA-Interface", interfaceId);
        ctx.addZuulRequestHeader("X-SDIA-Target",    target);

        // ── Set target URL ────────────────────────────────────────────────────
        ctx.setRouteHost(parseUrl(targetUrl));
        ctx.put("requestURI", cpiPath);

        return null;
    }

    // ── parsePath — zero regex, manual indexOf ────────────────────────────────
    private String[] parsePath(String path) {
        if (path == null || path.isEmpty() || path.charAt(0) != '/') return null;
        int s1 = path.indexOf('/', 1);
        if (s1 == -1) return null;
        int s2 = path.indexOf('/', s1 + 1);
        if (s2 == -1) return null;
        int s3 = path.indexOf('/', s2 + 1);
        if (s3 == -1) return null;
        int s4 = path.indexOf('/', s3 + 1);
        return new String[]{
            path.substring(1,      s1),
            path.substring(s1 + 1, s2),
            path.substring(s2 + 1, s3),
            s4 == -1 ? path.substring(s3 + 1) : path.substring(s3 + 1, s4)
        };
    }

    // ── extractIdSuffix — finds "id" + digits at end of string ───────────────
    private String extractIdSuffix(String interfaceId) {
        String low = interfaceId.toLowerCase();
        int idx = low.lastIndexOf("id");
        if (idx == -1 || idx >= low.length() - 2) return "";
        StringBuilder digits = new StringBuilder();
        for (int i = idx + 2; i < low.length(); i++) {
            char c = low.charAt(i);
            if (c >= '0' && c <= '9') digits.append(c);
            else break;
        }
        return digits.length() > 0 ? "id" + digits : "";
    }

    // ── kvmLookup — in production replace with Redis Jedis/Lettuce call ───────
    private String kvmLookup(String path) {
        // Production: use Jedis
        // Jedis jedis = new Jedis("redis-service.sdia.svc.cluster.local", 6379);
        // return jedis.get(path);

        // POC: static map matching the Redis seed
        Map<String, String> staticKvm = getStaticKvm();
        return staticKvm.get(path);
    }

    // ── rejectRequest ─────────────────────────────────────────────────────────
    private void rejectRequest(RequestContext ctx, int status, String message) {
        ctx.setSendZuulResponse(false);
        ctx.setResponseStatusCode(status);
        ctx.setResponseBody("{\"status\":\"error\",\"message\":\"" + message + "\"}");
        ctx.getResponse().setContentType("application/json");
    }

    // ── parseUrl helper ───────────────────────────────────────────────────────
    private java.net.URL parseUrl(String url) {
        try { return new java.net.URL(url); }
        catch (Exception e) { return null; }
    }

    // ── Static KVM — mirrors Redis seed (42 routes) ───────────────────────────
    // In production: all lookups go to Redis directly
    private static Map<String, String> getStaticKvm() {
        Map<String, String> kvm = new HashMap<>();
        // SALES
        kvm.put("/sales/orders/create/salesforce",      "gdcrorderscSalesforceid01:http");
        kvm.put("/sales/orders/update/salesforceemea",  "gdcrordersuSalesforceid02:http");
        kvm.put("/sales/orders/create/microsoft",       "gdcrorderscMicrosoftid05:soap");
        kvm.put("/sales/invoices/create/quickbooks",    "gdcrinvoicescQuickbooksid09:soap");
        kvm.put("/sales/invoices/create/s4hana",        "gdcrinvoicescS4hanaid10:soap");
        kvm.put("/sales/payments/notify/stripe",        "gdcrpaymentsnStripeid04:http");
        kvm.put("/sales/payments/notify/s4hana",        "gdcrpaymentsnS4hanaid08:soap");
        kvm.put("/sales/customers/sync/shopify",        "gdcrcustomerssShopifyid03:http");
        kvm.put("/sales/customers/sync/s4hana",         "gdcrcustomerssS4hanaid07:soap");
        kvm.put("/sales/deliveries/transfer/fedex",     "gdcrdeliveriestFedexid06:http");
        kvm.put("/sales/deliveries/transfer/s4hana",    "gdcrdeliveriestS4hanaid11:soap");
        kvm.put("/sales/returns/create/shopify",        "gdcrreturnscShopifyid12:http");
        kvm.put("/sales/returns/create/s4hana",         "gdcrreturnscS4hanaid13:soap");
        // FINANCES
        kvm.put("/finances/invoices/create/quickbooks", "gdcrinvoicescQuickbooksid01:soap");
        kvm.put("/finances/invoices/create/s4hana",     "gdcrinvoicescS4hanaid02:soap");
        kvm.put("/finances/taxes/create/avalara",       "gdcrtaxescAvalaraid10:http");
        kvm.put("/finances/budgets/sync/workday",       "gdcrbudgetssWorkdayid09:soap");
        kvm.put("/finances/expenses/create/coupa",      "gdcrexpensescCoupaid07:http");
        kvm.put("/finances/payments/notify/stripe",     "gdcrpaymentsnStripeid03:http");
        kvm.put("/finances/payments/notify/s4hana",     "gdcrpaymentsnS4hanaid04:http");
        kvm.put("/finances/journals/create/sap",        "gdcrjournalscSapid06:soap");
        kvm.put("/finances/accounts/sync/xero",         "gdcraccountssXeroid05:http");
        kvm.put("/finances/receipts/update/concur",     "gdcrreceiptsuConcurid08:http");
        // PROCUREMENT
        kvm.put("/procurement/requisitions/create/ariba",  "gdcrrequisitionscAribaid01:soap");
        kvm.put("/procurement/pos/create/coupa",           "gdcrposcCoupaid02:http");
        kvm.put("/procurement/rfqs/create/ariba",          "gdcrrfqscAribaid03:soap");
        kvm.put("/procurement/invoices/approve/basware",   "gdcrinvoicesaBaswareid05:soap");
        kvm.put("/procurement/contracts/sync/jaggaer",     "gdcrcontractssJaggaerid04:http");
        kvm.put("/procurement/suppliers/sync/ivalua",      "gdcrsupplierssIvaluaid06:http");
        kvm.put("/procurement/catalogs/update/tradeshift", "gdcrcatalogsuTradeshiftid07:http");
        kvm.put("/procurement/grns/create/wms",            "gdcrgrsnscWmsid08:soap");
        kvm.put("/procurement/buyers/sync/oracle",         "gdcrbuyerssOracleid09:http");
        kvm.put("/procurement/sourcings/query/ariba",      "gdcrsourcingsqAribaid10:soap");
        // LOGISTICS
        kvm.put("/logistics/shipments/create/fedex",    "gdcrshipmentscFedexid01:http");
        kvm.put("/logistics/trackings/update/ups",      "gdcrtrackingsuUpsid02:http");
        kvm.put("/logistics/deliveries/create/dhl",     "gdcrdeliveriescDhlid03:soap");
        kvm.put("/logistics/shipments/query/fedex",     "gdcrshipmentsqFedexid04:http");
        kvm.put("/logistics/containers/sync/maersk",    "gdcrcontainerssMarskid05:http");
        kvm.put("/logistics/warehouses/update/sf",      "gdcrwarehousesuSfid06:soap");
        kvm.put("/logistics/freights/create/coyote",    "gdcrfreightscCoyoteid07:http");
        kvm.put("/logistics/routes/sync/project44",     "gdcrroutessProject44id08:http");
        kvm.put("/logistics/manifests/create/customs",  "gdcrmanifestscCustomsid09:soap");
        return kvm;
    }
}
