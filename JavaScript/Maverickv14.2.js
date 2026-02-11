/**
 * ═══════════════════════════════════════════════════════════════════════════
 * 
 *   THE DCRP ROUTING ENGINE - "THE COMMANDER'S BRAIN"
 *   Domain-Centric Routing Pattern - Viana Pattern
 * 
 *   VERSION: 14.2 - PRODUCTION HARDENED EDITION
 *   AUTHOR: Ricardo Luz Holanda Viana
 *   DATE: 2026-02-09
 * 
 *   NEW IN V14.2 - PRODUCTION CRITICAL FIXES:
 *   ✓ Multi-node cache invalidation with TTL
 *   ✓ Segmented latency tracking (7 phases)
 *   ✓ Cache staleness detection
 *   ✓ Version-based cache validation
 *   ✓ Auto-refresh on KVM changes
 *   ✓ Detailed timing breakdown
 * 
 *   LATENCY SEGMENTS (NEW):
 *   Phase 0: Initialization          (0-2ms)
 *   Phase 1: Path parsing            (1-3ms)
 *   Phase 2: Action normalization    (0-5ms)
 *   Phase 3: Key computation         (1-2ms)
 *   Phase 4: KVM cache/parse         (0-10ms)
 *   Phase 5: KVM scan & match        (5-20ms)
 *   Phase 6: URL build & headers     (1-3ms)
 *   Total:                           (8-45ms typical)
 * 
 *   CACHE STRATEGY:
 *   - TTL: 60 seconds (configurable)
 *   - Version check: KVM hash comparison
 *   - Auto-invalidate: on KVM content change
 *   - Multi-node safe: each node validates independently
 * 
 * ═══════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════
// GLOBAL STATIC CACHE - With TTL and version tracking
// ═══════════════════════════════════════════════════════════════════════════
var GLOBAL_ACTION_MAP_CACHE;
var GLOBAL_KVM_CACHE;
var GLOBAL_CACHE_INITIALIZED = false;

// DEBUG VARIABLES (commented out for production - uncomment if needed)
// var GLOBAL_STATS_TOTAL_REQUESTS = 0;
// var GLOBAL_STATS_CACHE_HITS = 0;

// Cache configuration
var CACHE_TTL_MS = 60000; // 60 seconds TTL for KVM cache

/**
 * Simple hash function for cache validation
 * (Fast hash, not cryptographic - just for change detection)
 */
function fastHash(str) {
    var hash = 0;
    if (str.length === 0) return hash;
    for (var i = 0; i < str.length; i++) {
        var char = str.charCodeAt(i);
        hash = ((hash << 5) - hash) + char;
        hash = hash & hash; // Convert to 32bit integer
    }
    return hash;
}

/**
 * Initialize global static caches (called ONCE per deployment)
 */
function initializeGlobalCaches() {
    if (GLOBAL_CACHE_INITIALIZED) {
        return; // Already initialized
    }
    
    // ═══════════════════════════════════════════════════════════════════════
    // ACTION MAP - Static hash table (computed once)
    // 241 variants → 15 codes
    // ═══════════════════════════════════════════════════════════════════════
    GLOBAL_ACTION_MAP_CACHE = {
        // Single chars
        "c":"c","r":"r","u":"u","d":"d","s":"s","p":"p","a":"a","n":"n",
        "q":"q","v":"v","t":"t","e":"e","m":"m","x":"x","b":"b",
        
        // CREATE (17)
        "create":"c","creation":"c","creating":"c","creates":"c","created":"c",
        "add":"c","adding":"c","adds":"c","added":"c",
        "insert":"c","inserting":"c","inserts":"c","inserted":"c",
        "new":"c","provision":"c","provisioning":"c","register":"c",
        
        // READ (21)
        "read":"r","reading":"r","reads":"r",
        "retrieve":"r","retrieval":"r","retrieving":"r","retrieves":"r","retrieved":"r",
        "get":"r","getting":"r","gets":"r",
        "fetch":"r","fetching":"r","fetches":"r","fetched":"r",
        "obtain":"r","obtaining":"r","obtains":"r","obtained":"r",
        "view":"r","list":"r",
        
        // UPDATE (23)
        "update":"u","updating":"u","updates":"u","updated":"u","upd":"u",
        "modify":"u","modification":"u","modifying":"u","modifies":"u","modified":"u",
        "change":"u","changing":"u","changes":"u","changed":"u",
        "edit":"u","editing":"u","edits":"u","edited":"u",
        "patch":"u","patching":"u","patches":"u","patched":"u","revise":"u",
        
        // DELETE (21)
        "delete":"d","deletion":"d","deleting":"d","deletes":"d","deleted":"d","del":"d",
        "remove":"d","removal":"d","removing":"d","removes":"d","removed":"d",
        "erase":"d","erasing":"d","erases":"d","erased":"d",
        "cancel":"d","cancellation":"d","canceling":"d","cancelling":"d",
        "deactivate":"d","purge":"d",
        
        // SYNC (13)
        "sync":"s","syncing":"s","syncs":"s","synced":"s",
        "synchronize":"s","synchronization":"s","synchronizing":"s","synchronizes":"s","synchronized":"s",
        "replicate":"s","replicating":"s","replicates":"s","replicated":"s",
        
        // POST (9)
        "post":"p","posting":"p","posts":"p","posted":"p",
        "publish":"p","publishing":"p","publishes":"p","published":"p","send":"p",
        
        // APPROVE (11)
        "approve":"a","approval":"a","approving":"a","approves":"a","approved":"a",
        "authorize":"a","authorization":"a","authorizing":"a","authorizes":"a","authorized":"a",
        "confirm":"a",
        
        // NOTIFY (15)
        "notify":"n","notification":"n","notifying":"n","notifies":"n","notified":"n",
        "alert":"n","alerting":"n","alerts":"n","alerted":"n",
        "inform":"n","informing":"n","informs":"n","informed":"n",
        "broadcast":"n","message":"n",
        
        // QUERY (15)
        "query":"q","querying":"q","queries":"q","queried":"q",
        "search":"q","searching":"q","searches":"q","searched":"q",
        "find":"q","finding":"q","finds":"q",
        "lookup":"q","filter":"q","filtering":"q","filters":"q",
        
        // VALIDATE (13)
        "validate":"v","validation":"v","validating":"v","validates":"v","validated":"v","val":"v",
        "verify":"v","verification":"v","verifying":"v","verifies":"v","verified":"v",
        "check":"v","test":"v",
        
        // TRACK/TRANSFORM (19)
        "track":"t","tracking":"t","tracks":"t","tracked":"t","tra":"t",
        "trace":"t","tracing":"t","traces":"t","traced":"t",
        "transform":"t","transformation":"t","transforming":"t","transforms":"t","transformed":"t",
        "convert":"t","converting":"t","converts":"t","converted":"t","map":"t",
        
        // ENRICH (9)
        "enrich":"e","enrichment":"e","enriching":"e","enriches":"e","enriched":"e",
        "enhance":"e","enhancing":"e","enhances":"e","enhanced":"e",
        
        // MERGE (9)
        "merge":"m","merging":"m","merges":"m","merged":"m",
        "combine":"m","combining":"m","combines":"m","combined":"m","consolidate":"m",
        
        // EXECUTE (11)
        "execute":"x","execution":"x","executing":"x","executes":"x","executed":"x",
        "run":"x","running":"x","runs":"x",
        "process":"x","processing":"x","trigger":"x",
        
        // BATCH (9)
        "batch":"b","batching":"b","batches":"b","batched":"b",
        "bulk":"b","bulking":"b","bulks":"b","mass":"b","multiple":"b"
    };
    
    GLOBAL_CACHE_INITIALIZED = true;
    
    // DEBUG: Uncomment to trace cache initialization
    // print("[DCRP-v14.2] Global action map initialized. Variants: 241, Codes: 15");
}

/**
 * Parse and cache KVM entries with TTL and version tracking
 * Multi-node safe: validates cache on every access
 */
function parseKVMEntries(kvmString, timing) {
    var t4a = new Date().getTime();
    
    var isCacheHit = false;
    var cacheStale = false;
    var currentTime = new Date().getTime();
    var kvmHash = fastHash(kvmString);
    
    // Check if cache exists, is valid, and not expired
    if (GLOBAL_KVM_CACHE && 
        GLOBAL_KVM_CACHE.hash === kvmHash &&
        (currentTime - GLOBAL_KVM_CACHE.timestamp) < CACHE_TTL_MS) {
        
        // Cache HIT!
        isCacheHit = true;
        
        // DEBUG: Uncomment to track cache hits
        // GLOBAL_STATS_CACHE_HITS++;
        
    } else {
        // Cache MISS or STALE - reparse
        if (GLOBAL_KVM_CACHE) {
            cacheStale = true; // Had cache but it's stale
            
            // DEBUG: Uncomment to trace cache invalidation
            // print("[DCRP-v14.2] KVM cache invalidated (TTL or content changed). New hash: " + kvmHash);
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
        
        GLOBAL_KVM_CACHE = {
            hash: kvmHash,
            timestamp: currentTime,
            entries: parsed,
            count: parsed.length
        };
        
        isCacheHit = false;
    }
    
    var t4b = new Date().getTime();
    timing.phase4_kvm_parse = t4b - t4a;
    
    return {
        entries: GLOBAL_KVM_CACHE.entries,
        cacheHit: isCacheHit,
        cacheStale: cacheStale,
        cacheAge: currentTime - GLOBAL_KVM_CACHE.timestamp,
        kvmHash: kvmHash
    };
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN ROUTING FUNCTION
// ═══════════════════════════════════════════════════════════════════════════
function resolveDCRPRouting() {
    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 0: Initialization & timer start
    // ═══════════════════════════════════════════════════════════════════════
    var t0 = new Date().getTime();
    var timing = {
        phase0_init: 0,
        phase1_path_parse: 0,
        phase2_action_normalize: 0,
        phase3_key_compute: 0,
        phase4_kvm_parse: 0,
        phase5_kvm_scan: 0,
        phase6_url_headers: 0,
        total: 0
    };
    
    initializeGlobalCaches();
    
    // DEBUG: Uncomment to track total requests
    // GLOBAL_STATS_TOTAL_REQUESTS++;
    
    var cpiHost = context.getVariable("target.cpi.host");
    var proxyPathSuffix = context.getVariable("proxy.pathsuffix");
    var idinterface = context.getVariable("kvm.idinterface");
    
    if (!proxyPathSuffix || !idinterface) {
        context.setVariable("error.code", !proxyPathSuffix ? "400" : "500");
        context.setVariable("error.message", !proxyPathSuffix ? "Missing proxy.pathsuffix" : "KVM not configured");
        throw new Error(!proxyPathSuffix ? "Missing proxy.pathsuffix" : "KVM not configured");
    }
    
    var t1 = new Date().getTime();
    timing.phase0_init = t1 - t0;
    
    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 1: Path parsing
    // ═══════════════════════════════════════════════════════════════════════
    var pathArray = proxyPathSuffix.split("/");
    var pathLen = pathArray.length;
    var entity, actionLong, vendorOrId;
    
    if (pathLen === 4) {
        entity = pathArray[1];
        actionLong = pathArray[2];
        vendorOrId = pathArray[3];
    } else if (pathLen === 5) {
        entity = pathArray[2];
        actionLong = pathArray[3];
        vendorOrId = pathArray[4];
    } else {
        context.setVariable("error.code", "400");
        throw new Error("Invalid path format");
    }
    
    var t2 = new Date().getTime();
    timing.phase1_path_parse = t2 - t1;
    
    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 2: Action normalization
    // ═══════════════════════════════════════════════════════════════════════
    var actionShort;
    var actionLen = actionLong.length;
    var actionLookupUsed = false;
    
    if (actionLen === 1) {
        actionShort = actionLong.toLowerCase();
    } else {
        var actionLower = actionLong.toLowerCase();
        actionShort = GLOBAL_ACTION_MAP_CACHE[actionLower];
        actionLookupUsed = true;
        
        if (!actionShort) {
            context.setVariable("error.code", "400");
            throw new Error("Unknown action: " + actionLong);
        }
    }
    
    var t3 = new Date().getTime();
    timing.phase2_action_normalize = t3 - t2;
    
    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 3: Key computation
    // ═══════════════════════════════════════════════════════════════════════
    var compactKey = "dcrp" + entity + actionShort;
    var vendorForKey = vendorOrId;
    
    if (vendorOrId.length > 0 && vendorOrId.charAt(0).toLowerCase() === actionShort) {
        vendorForKey = vendorOrId.substring(1);
    }
    
    var extendedKey = compactKey + vendorForKey;
    var compactLen = compactKey.length;
    var extendedLen = extendedKey.length;
    
    var t4 = new Date().getTime();
    timing.phase3_key_compute = t4 - t3;
    
    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 4: KVM cache/parse
    // ═══════════════════════════════════════════════════════════════════════
    var kvmResult = parseKVMEntries(idinterface, timing);
    var kvmEntries = kvmResult.entries;
    var isCacheHit = kvmResult.cacheHit;
    var entryCount = kvmEntries.length;
    
    var t5 = new Date().getTime();
    // timing.phase4_kvm_parse already set inside parseKVMEntries
    
    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 5: KVM scan & match
    // ═══════════════════════════════════════════════════════════════════════
    var iflowId = null;
    var adapter = null;
    var matchedEntry = null;
    var matchType = "none";
    var scanIterations = 0;
    
    // Extended match
    for (var i = 0; i < entryCount; i++) {
        scanIterations++;
        var entry = kvmEntries[i];
        var key = entry.key;
        
        if (key.length > extendedLen && key.substring(0, extendedLen) === extendedKey) {
            var suffix = key.substring(extendedLen);
            
            if (suffix.length > 2 && 
                suffix.charCodeAt(0) === 105 && 
                suffix.charCodeAt(1) === 100) {
                
                iflowId = suffix;
                adapter = entry.adapter;
                matchedEntry = key;
                matchType = "extended";
                break;
            }
        }
    }
    
    // Compact match (if needed)
    if (!iflowId) {
        var httpMatch = null, cxfMatch = null;
        var httpCount = 0, cxfCount = 0;
        
        for (var j = 0; j < entryCount; j++) {
            scanIterations++;
            var entry2 = kvmEntries[j];
            var key2 = entry2.key;
            
            if (key2.length > compactLen && key2.substring(0, compactLen) === compactKey) {
                var suffix2 = key2.substring(compactLen);
                
                if (suffix2.indexOf(vendorOrId) !== -1 || suffix2.indexOf(vendorForKey) !== -1) {
                    var idMatch = suffix2.match(/id\d+/);
                    if (idMatch) {
                        var adp = entry2.adapter;
                        
                        if (adp === "http") {
                            httpCount++;
                            if (!httpMatch) httpMatch = { id: idMatch[0], adapter: "http", entry: key2 };
                        } else if (adp === "cxf") {
                            cxfCount++;
                            if (!cxfMatch) cxfMatch = { id: idMatch[0], adapter: "cxf", entry: key2 };
                        }
                    }
                }
            }
        }
        
        if (httpCount > 1 || cxfCount > 1) {
            context.setVariable("error.code", "409");
            throw new Error("Conflict: Multiple iFlows");
        }
        
        if (httpMatch) {
            iflowId = httpMatch.id;
            adapter = "http";
            matchedEntry = httpMatch.entry;
            matchType = "compact";
        } else if (cxfMatch) {
            iflowId = cxfMatch.id;
            adapter = "cxf";
            matchedEntry = cxfMatch.entry;
            matchType = "compact";
        }
    }
    
    if (!iflowId) {
        context.setVariable("error.code", "404");
        throw new Error("No route found");
    }
    
    var t6 = new Date().getTime();
    timing.phase5_kvm_scan = t6 - t5;
    
    // ═══════════════════════════════════════════════════════════════════════
    // PHASE 6: URL build & headers
    // ═══════════════════════════════════════════════════════════════════════
    var targetUrl = cpiHost + "/" + adapter + "/dcrp/" + entity + "/" + actionShort + "/" + iflowId;
    
    context.setVariable("target.url", targetUrl);
    context.setVariable("request.header.x-iflow-id", iflowId + "-" + vendorOrId);
    context.setVariable("request.header.x-package-name", context.getVariable("kvm.packagename") || "unknown");
    context.setVariable("request.header.x-sap-process", context.getVariable("kvm.sapprocess") || "unknown");
    context.setVariable("request.header.x-entity", entity);
    context.setVariable("request.header.x-action", actionShort);
    context.setVariable("request.header.x-adapter", adapter);
    context.setVariable("request.header.x-matched-kvm-entry", matchedEntry);
    context.setVariable("request.header.x-original-action", actionLong);
    context.setVariable("dcrp.routing.success", "true");
    
    var t7 = new Date().getTime();
    timing.phase6_url_headers = t7 - t6;
    timing.total = t7 - t0;
    
    // ═══════════════════════════════════════════════════════════════════════
    // ANALYTICS: Set all metrics
    // ═══════════════════════════════════════════════════════════════════════
    
    // Core metrics
    context.setVariable("statistics.dcrp_latency", timing.total);
    context.setVariable("statistics.dcrp_cache_hit", isCacheHit ? "true" : "false");
    context.setVariable("statistics.dcrp_cache_stale", kvmResult.cacheStale ? "true" : "false");
    context.setVariable("statistics.dcrp_cache_age_ms", kvmResult.cacheAge);
    context.setVariable("statistics.dcrp_kvm_hash", kvmResult.kvmHash);
    
    // Segmented latency (NEW!)
    context.setVariable("statistics.dcrp_latency_phase0_init", timing.phase0_init);
    context.setVariable("statistics.dcrp_latency_phase1_path", timing.phase1_path_parse);
    context.setVariable("statistics.dcrp_latency_phase2_action", timing.phase2_action_normalize);
    context.setVariable("statistics.dcrp_latency_phase3_key", timing.phase3_key_compute);
    context.setVariable("statistics.dcrp_latency_phase4_kvm", timing.phase4_kvm_parse);
    context.setVariable("statistics.dcrp_latency_phase5_scan", timing.phase5_kvm_scan);
    context.setVariable("statistics.dcrp_latency_phase6_url", timing.phase6_url_headers);
    
    // Business metrics
    context.setVariable("statistics.dcrp_entity", entity);
    context.setVariable("statistics.dcrp_vendor", vendorOrId);
    context.setVariable("statistics.dcrp_action_original", actionLong);
    context.setVariable("statistics.dcrp_action_normalized", actionShort);
    context.setVariable("statistics.dcrp_action_lookup_used", actionLookupUsed ? "true" : "false");
    context.setVariable("statistics.dcrp_match_type", matchType);
    context.setVariable("statistics.dcrp_adapter", adapter);
    context.setVariable("statistics.dcrp_iflow_id", iflowId);
    
    // Performance metrics
    context.setVariable("statistics.dcrp_kvm_entries", entryCount);
    context.setVariable("statistics.dcrp_scan_iterations", scanIterations);
    context.setVariable("statistics.dcrp_path_length", pathLen);
    
    // DEBUG: Global stats (uncomment if needed)
    // context.setVariable("statistics.dcrp_total_requests", GLOBAL_STATS_TOTAL_REQUESTS);
    // context.setVariable("statistics.dcrp_total_cache_hits", GLOBAL_STATS_CACHE_HITS);
    // context.setVariable("statistics.dcrp_cache_hit_rate", 
    //     GLOBAL_STATS_TOTAL_REQUESTS > 0 
    //         ? ((GLOBAL_STATS_CACHE_HITS / GLOBAL_STATS_TOTAL_REQUESTS) * 100).toFixed(2) + "%" 
    //         : "0%");
    
    // Version & config
    context.setVariable("statistics.dcrp_version", "14.2");
    context.setVariable("statistics.dcrp_cache_ttl_ms", CACHE_TTL_MS);
}
