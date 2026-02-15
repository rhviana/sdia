/**
* ═══════════════════════════════════════════════════════════════════════════
*
* THE DCRP ROUTING ENGINE 
*
* MISSION: Transform static gateway infrastructure into intelligent,
* metadata-driven routing orchestration at enterprise scale.
*
* CAPABILITIES:
* ✓ Dynamic iFlow resolution via Key-Value Map metadata
* ✓ Path parameter preservation (single or multi-level IDs)
* ✓ Query string integrity across gateway boundaries
* ✓ Governance header injection (X-SenderId, X-CorrelationId)
* ✓ Analytics variable collection for observability
* ✓ Zero code deployment for new integrations (metadata-only scaling)
*
* AUTHOR: Viana — SAP BTP Integration Suite Expert
* PATTERN: Domain-Centric Routing Pattern (DCRP)
* VERSION: 5.0 — Proof of Concept ready - Basic functions
*
* ═══════════════════════════════════════════════════════════════════════════
*/
function resolveDcrpRouting() {
try {
var cpiHost = context.getVariable(“target.cpi.host”);
var cpiBasepathRaw = context.getVariable(“target.cpi.basepath”);
var iflowname = context.getVariable(“iflowname”);
var pathSuffix = context.getVariable(“proxy.pathsuffix”);
var senderId = context.getVariable(“request.header.X-SenderId”);
var correlationId = context.getVariable(“request.header.X-CorrelationId”);
var queryParams = context.getVariable(“request.querystring”) || “”;

if (!cpiHost || !cpiBasepathRaw || !iflowname || !pathSuffix) {
context.setVariable(“routing.failed”, true);
context.setVariable(“routing.error”, “MISSING_REQUIRED_VARIABLES”);
throw new Error(“DCRP: Missing required variables for routing”);
}

// ========================================
// SECTION 1.5: EXTRACT PATH SEGMENTS
// ========================================

var cleanPathSuffix = pathSuffix.replace(/^\/+/, ‘’);
var segments = cleanPathSuffix.split(‘/’);
var firstSegment = segments[0]; // “orders” ou “fodase”
var remainingPath = segments.slice(1).join(‘/’); // “inbound”

// Build dynamic basepath: /http/{firstSegment}
var cpiBasepath = “/http/” + firstSegment;

// ========================================
// SECTION 2: FLEXIBLE DELIMITER DETECTION
// ========================================

var supportedDelimiters = [‘,’, ‘;’, ‘|’, ‘/’, ‘\\’, ‘[‘, ‘]’, ‘(‘, ‘)’, ‘-’, ‘_’];
var delimiter = null;

for (var i = 0; i < supportedDelimiters.length; i++) {
if (iflowname.indexOf(supportedDelimiters[i]) !== -1) {
delimiter = supportedDelimiters[i];
break;
}
}

if (!delimiter) {
context.setVariable(“routing.failed”, true);
context.setVariable(“routing.error”, “NO_DELIMITER_FOUND”);
throw new Error(“DCRP: No valid delimiter found in KVM value”);
}

// ========================================
// SECTION 3: KVM PARSING & PATH MATCHING
// ========================================

var entries = iflowname.split(delimiter);
var routes = [];

for (var j = 0; j < entries.length; j++) {
var entry = entries[j].trim();
if (entry.length === 0) continue;

var parts = entry.split(‘:’);
if (parts.length !== 2) {
context.setVariable(“routing.failed”, true);
context.setVariable(“routing.error”, “INVALID_KVM_FORMAT”);
throw new Error(“DCRP: Invalid KVM format — expected ‘path:iflowname’, got: “ + entry);
}

routes.push({
path: parts[0].trim(),
iflow: parts[1].trim()
});
}

routes.sort(function(a, b) {
return b.path.length — a.path.length;
});

var matchedRoute = null;

for (var k = 0; k < routes.length; k++) {
var routePath = routes[k].path.replace(/^\/+/, ‘’);

if (remainingPath === routePath || remainingPath.indexOf(routePath + ‘/’) === 0) {
matchedRoute = routes[k];
break;
}
}

if (!matchedRoute) {
context.setVariable(“routing.failed”, true);
context.setVariable(“routing.error”, “ROUTE_NOT_FOUND”);
context.setVariable(“routing.pathsuffix”, pathSuffix);
throw new Error(“DCRP: No matching route found for path: “ + pathSuffix);
}

// ========================================
// SECTION 4: GOVERNANCE HEADER INJECTION
// ========================================

if (senderId) {
context.setVariable(“request.header.X-SenderId”, senderId);
}

if (correlationId) {
context.setVariable(“request.header.X-CorrelationId”, correlationId);
}

// ========================================
// SECTION 5: DYNAMIC URL CONSTRUCTION
// ========================================

var targetUrl = cpiHost + cpiBasepath + “/” + matchedRoute.path;

if (queryParams && queryParams.length > 0) {
targetUrl += “?” + queryParams;
}

context.setVariable(“target.url”, targetUrl);
context.setVariable(“target.copy.pathsuffix”, false);
context.setVariable(“target.copy.queryparams”, false);

// ========================================
// SUCCESS: SET ROUTING METADATA
// ========================================

context.setVariable(“routing.success”, true);
context.setVariable(“routing.matched.path”, matchedRoute.path);
context.setVariable(“routing.matched.iflow”, matchedRoute.iflow);
context.setVariable(“routing.target.url”, targetUrl);
context.setVariable(“routing.selected.basepath”, cpiBasepath);

context.setVariable(“idiflow”, matchedRoute.iflow);
context.setVariable(“idcorrelation”, context.getVariable(“request.header.X-CorrelationId”));
context.setVariable(“idsender”, senderId || “UNKNOWN”);

} catch (error) {
context.setVariable(“routing.failed”, true);
context.setVariable(“routing.exception”, error.message || error.toString());

print(“DCRP Routing Error: “ + error.message);
print(“PathSuffix: “ + pathSuffix);
print(“KVM Value: “ + iflowname);
}
}
