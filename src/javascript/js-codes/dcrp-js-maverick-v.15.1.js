
/**
 * ============================================================================
 * THE DCRP ROUTING ENGINE V15.1 - "THE MAVERICK GHOST"
 * Domain-Centric Routing Pattern - Ricardo Viana Pattern
 * ============================================================================
 *
 * VERSION: 15.1 - THE MAVERICK GHOST EDITION
 * AUTHOR: Ricardo Luz Holanda Viana
 * DATE: 2026-02-12
 * LICENSE: Creative Commons Attribution 4.0 International (CC BY 4.0)
 * DOI: 10.5281/zenodo.18619641 (V15.1) - 12/02/2026
 * Identified: https://doi.org/10.6084/m9.figshare.31331683 - 13/02/2026
 * GITHUB: https://github.com/rhviana/gdcr
 *
 * ============================================================================
 */

// ============================================================================
// GLOBAL CONFIGURATION
// ============================================================================
var CACHE_TTL_MS = 60000; // 60 seconds

var GLOBAL_ACTION_MAP;
var GLOBAL_KVM_CACHE;
var GLOBAL_CACHE_INITIALIZED = false;

var GLOBAL_STATS_TOTAL_REQUESTS = 0;
var GLOBAL_STATS_CACHE_HITS = 0;

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================
function fastHash(str) {
  var hash = 2166136261;
  for (var i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash += (hash << 1) + (hash << 4) + (hash << 7) + (hash << 8) + (hash << 24);
  }
  return hash >>> 0;
}

function startsWithCI(str, prefix) {
  if (str.length < prefix.length) return false;
  for (var i = 0; i < prefix.length; i++) {
    var c1 = str.charCodeAt(i);
    var c2 = prefix.charCodeAt(i);
    if (c1 >= 65 && c1 <= 90) c1 += 32;
    if (c2 >= 65 && c2 <= 90) c2 += 32;
    if (c1 !== c2) return false;
  }
  return true;
}

function extractIdFast(key, startPos) {
  var len = key.length;
  if (len - startPos < 4) return null;
  // 'i''d'
  if (key.charCodeAt(startPos) !== 105 || key.charCodeAt(startPos + 1) !== 100) return null;

  var numStart = startPos + 2;
  var numEnd = numStart;
  while (numEnd < len) {
    var c = key.charCodeAt(numEnd);
    if (c < 48 || c > 57) break;
    numEnd++;
  }
  if (numEnd - numStart < 2) return null;
  return key.substring(startPos, numEnd); // "idNN..."
}

// ============================================================================
// INITIALIZATION
// ============================================================================
function initializeGlobalCaches() {
  if (GLOBAL_CACHE_INITIALIZED) return;

  GLOBAL_ACTION_MAP = new Map([
    // single-letter passthroughs
    ["c","c"], ["r","r"], ["u","u"], ["d","d"], ["s","s"],
    ["p","p"], ["a","a"], ["n","n"], ["q","q"], ["v","v"],
    ["t","t"], ["e","e"], ["m","m"], ["x","x"], ["b","b"],
    // CREATE
    ["create","c"], ["creation","c"], ["creating","c"], ["creates","c"],
    ["created","c"], ["add","c"], ["adding","c"], ["adds","c"],
    ["added","c"], ["insert","c"], ["inserting","c"], ["inserts","c"],
    ["inserted","c"], ["new","c"], ["provision","c"], ["provisioning","c"],
    ["register","c"],
    // READ
    ["read","r"], ["reading","r"], ["reads","r"], ["retrieve","r"],
    ["retrieval","r"], ["retrieving","r"], ["retrieves","r"],
    ["get","r"], ["getting","r"], ["gets","r"], ["fetch","r"],
    ["fetching","r"], ["fetches","r"], ["fetched","r"], ["obtain","r"],
    ["obtaining","r"], ["obtains","r"], ["obtained","r"], ["view","r"],
    ["list","r"],
    // UPDATE
    ["update","u"], ["updating","u"], ["updates","u"], ["updated","u"],
    ["upd","u"], ["modify","u"], ["modification","u"], ["modifying","u"],
    ["modifies","u"], ["change","u"], ["changing","u"], ["changes","u"],
    ["changed","u"], ["edit","u"], ["editing","u"], ["edits","u"],
    ["edited","u"], ["patch","u"], ["patching","u"], ["patches","u"],
    ["patched","u"], ["revise","u"],
    // DELETE
    ["delete","d"], ["deletion","d"], ["deleting","d"], ["deletes","d"],
    ["deleted","d"], ["remove","d"], ["removal","d"], ["removing","d"],
    ["removes","d"], ["removed","d"], ["erase","d"], ["erasing","d"],
    ["erases","d"], ["erased","d"], ["cancel","d"], ["cancellation","d"],
    ["canceling","d"], ["cancelling","d"], ["deactivate","d"], ["purge","d"],
    // SYNC
    ["sync","s"], ["syncing","s"], ["syncs","s"], ["synced","s"],
    ["synchronize","s"], ["synchronization","s"], ["synchronizing","s"],
    ["replicate","s"], ["replicating","s"], ["replicates","s"], ["replicated","s"],
    // POST
    ["post","p"], ["posting","p"], ["posts","p"], ["posted","p"],
    ["publish","p"], ["publishing","p"], ["publishes","p"], ["published","p"],
    // APPROVE
    ["approve","a"], ["approval","a"], ["approving","a"], ["approves","a"],
    ["authorize","a"], ["authorization","a"], ["authorizing","a"],
    ["authorizes","a"], ["confirm","a"],
    // NOTIFY
    ["notify","n"], ["notification","n"], ["notifying","n"], ["notifies","n"],
    ["alert","n"], ["alerting","n"], ["alerts","n"], ["alerted","n"],
    ["inform","n"], ["informing","n"], ["informs","n"], ["informed","n"],
    ["broadcast","n"], ["message","n"],
    // QUERY
    ["query","q"], ["querying","q"], ["queries","q"], ["queried","q"],
    ["search","q"], ["searching","q"], ["searches","q"], ["searched","q"],
    ["find","q"], ["finding","q"], ["finds","q"], ["lookup","q"],
    ["filter","q"], ["filtering","q"], ["filters","q"], ["filtering","q"]
  ]);

  GLOBAL_CACHE_INITIALIZED = true;
}

// ============================================================================
// KVM PARSING AND CACHING
// ============================================================================
function parseKVMEntries(kvmString) {
  var currentTime = new Date().getTime();
  var kvmHash = fastHash(kvmString);

  if (
    GLOBAL_KVM_CACHE &&
    GLOBAL_KVM_CACHE.hash === kvmHash &&
    (currentTime - GLOBAL_KVM_CACHE.timestamp) < CACHE_TTL_MS
  ) {
    GLOBAL_STATS_CACHE_HITS++;
    return {
      entries: GLOBAL_KVM_CACHE.entries,
      cacheHit: true,
      cacheAge: currentTime - GLOBAL_KVM_CACHE.timestamp,
      kvmHash: kvmHash
    };
  }

  var entries = kvmString.split(",");
  var parsed = [];

  for (var i = 0; i < entries.length; i++) {
    var entry = entries[i].trim();
    if (!entry) continue;
    var colonPos = entry.indexOf(":");
    if (colonPos === -1) continue;
    parsed.push({
      key: entry.substring(0, colonPos),
      adapter: entry.substring(colonPos + 1),
      full: entry
    });
  }

  parsed.sort(function (a, b) {
    return a.key < b.key ? -1 : (a.key > b.key ? 1 : 0);
  });

  GLOBAL_KVM_CACHE = {
    hash: kvmHash,
    timestamp: currentTime,
    entries: parsed,
    count: parsed.length
  };

  return { entries: parsed, cacheHit: false, cacheAge: 0, kvmHash: kvmHash };
}

// ============================================================================
// BINARY SEARCH (O(log n) KVM LOOKUP)
// ============================================================================
function binarySearchKVM(sortedEntries, searchKey) {
  var left = 0;
  var right = sortedEntries.length - 1;
  var iterations = 0;

  while (left <= right) {
    iterations++;
    var mid = (left + right) >>> 1;
    var entry = sortedEntries[mid];
    var key = entry.key;

    if (startsWithCI(key, searchKey)) {
      var suffix = key.substring(searchKey.length);
      if (suffix.length >= 4 &&
          suffix.charCodeAt(0) === 105 && // 'i'
          suffix.charCodeAt(1) === 100) { // 'd'
        return { entry: entry, iterations: iterations };
      }
    }

    if (key < searchKey) left = mid + 1;
    else right = mid - 1;
  }

  return null;
}

// ============================================================================
// PATH PARSING
// ============================================================================
function parsePath(proxyPathSuffix) {
  var pathArray = proxyPathSuffix.split("/");
  var filtered = [];
  for (var i = 0; i < pathArray.length; i++) {
    if (pathArray[i]) filtered.push(pathArray[i]);
  }
  var len = filtered.length;
  if (len < 3 || len > 4) throw new Error("Invalid path format.");

  return {
    domain: filtered[0],
    entity: filtered[1],
    action: filtered[2],
    vendor: len === 4 ? filtered[3] : "",
    pathLength: len
  };
}

// ============================================================================
// MAIN ROUTING FUNCTION
// ============================================================================
function resolveDCRPRouting() {
  var t0 = new Date().getTime();
  initializeGlobalCaches();
  GLOBAL_STATS_TOTAL_REQUESTS++;

  var cpiHost = context.getVariable("host");
  var proxyPathSuffix = context.getVariable("pathsuffix");
  var kvmIdInterface = context.getVariable("stringinterface");

  if (!proxyPathSuffix) throw new Error("Missing proxy.pathsuffix");
  if (!kvmIdInterface) throw new Error("KVM not configured (stringinterface)");
  if (!cpiHost) cpiHost = "https://default-cpi.hana.ondemand.com";

  var parsed = parsePath(proxyPathSuffix);
  var entity = parsed.entity;
  var action = parsed.action;
  var vendor = parsed.vendor;

  var actionLower = action.toLowerCase();
  var actionCode = GLOBAL_ACTION_MAP.get(actionLower);

  if (!actionCode) {
    if (action.length === 1) actionCode = actionLower;
    else throw new Error("Unknown action: " + action);
  }

  var searchKey = "dcrp" + entity + actionCode + vendor;

  var kvmResult = parseKVMEntries(kvmIdInterface);
  var kvmEntries = kvmResult.entries;
  var isCacheHit = kvmResult.cacheHit;

  var searchResult = binarySearchKVM(kvmEntries, searchKey);
  if (!searchResult) throw new Error("No route found for: " + searchKey);

  var matchedEntry = searchResult.entry;
  var iflowId = extractIdFast(matchedEntry.key, searchKey.length);
  var adapter = matchedEntry.adapter;

  var targetUrl = cpiHost + "/" + adapter + "/dcrp/" + entity + "/" + actionCode + "/" + iflowId;
  context.setVariable("target.url", targetUrl);

  // Header Enrichment
  context.setVariable("request.header.x-iflow-id", iflowId);
  context.setVariable("request.header.x-package-name", context.getVariable("package") || "unknown");
  context.setVariable("request.header.x-sap-process", context.getVariable("process") || "unknown");
  context.setVariable("request.header.x-dcrp-version", "15.1");
  context.setVariable("request.header.x-dcrp-latency", (new Date().getTime() - t0) + "ms");
  context.setVariable("request.header.x-dcrp-cache-hit", isCacheHit ? "true" : "false");

  context.setVariable("dcrp.routing.success", "true");
}

try {
  resolveDCRPRouting();
} catch (error) {
  context.setVariable("error.code", "500");
  context.setVariable("error.message", error.message);
  context.setVariable("dcrp.routing.success", "false");
  throw error;
}
