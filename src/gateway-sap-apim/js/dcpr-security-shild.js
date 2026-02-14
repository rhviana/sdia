/** catch-all route from malicious requests
* ============================================
 * DCRP SECURITY SHIELD v1.0
 * ============================================
 * PURPOSE: Protect
 * AUTHOR: Ricardo Viana
 * RUNS: BEFORE JS-Routing in Proxy PreFlow
 * 
 * FEATURES:
 * - Path Traversal Protection
 * - SQL Injection Detection
 * - XSS Protection
 * - Domain Whitelist Enforcement
 * - Header Validation
 * - Bot Protection
 * ============================================
 */
function hackingProtection() {
    try {
        // ============================================
        // CONTEXT EXTRACTION
        // ============================================
        var pathSuffix = context.getVariable("proxy.pathsuffix") || "";
        var queryString = context.getVariable("request.querystring") || "";
        var userAgent = context.getVariable("request.header.User-Agent") || "";
        var contentType = context.getVariable("request.header.Content-Type") || "";
        var method = context.getVariable("request.verb") || "";
        var clientIp = context.getVariable("client.ip") || "";

        // ============================================
        // SECTION 1: PATH TRAVERSAL PROTECTION
        // ============================================
        var pathTraversalPatterns = [
            /\.\./, // ../
            /%2e%2e/i, // URL-encoded ..
            /%252e/i, // Double URL-encoded .
            /\.\\/, // .\ (Windows path)
            /%5c/i, // URL-encoded backslash
            /\/\//, // Double slashes
            /etc\/passwd/i, // Linux system files
            /windows\/system/i, // Windows system paths
            /proc\/self/i, // Linux proc filesystem
            /\.\.%2f/i, // Mixed encoding
            /\.\.;/i // Semicolon bypass attempt
        ];

        for (var i = 0; i < pathTraversalPatterns.length; i++) {
            if (pathTraversalPatterns[i].test(pathSuffix)) {
                context.setVariable("security.threat.detected", "PATH_TRAVERSAL");
                context.setVariable("security.threat.pattern", pathTraversalPatterns[i].toString());
                context.setVariable("security.threat.path", pathSuffix);
                context.setVariable("security.threat.ip", clientIp);
                throw new Error("SECURITY: Path Traversal attempt detected");
            }
        }

        // ============================================
        // SECTION 2: DOMAIN WHITELIST VALIDATION
        // ============================================
        var allowedDomains = [
            "sales", "orders", "customers", "invoices", "prices", "quotations",
            "finance", "accounts", "journals", "payments", "reconciliations",
            "reports", "closings", "taxes", "budgets",
            "logistics", "shipments", "inventory", "deliveries", "warehouses",
            "tracking", "carriers", "returns", "pickpack",
            "procurement", "requisitions", "suppliers", "contracts",
            "buyers", "approvals", "receipts", "catalogs"
        ];

        var segments = pathSuffix.split("/").filter(function(s) {
            return s.length > 0;
        });
        var firstSegment = segments.length > 0 ? segments[0].toLowerCase() : "";

        var isDomainAllowed = false;
        for (var j = 0; j < allowedDomains.length; j++) {
            if (firstSegment === allowedDomains[j]) {
                isDomainAllowed = true;
                break;
            }
        }

        if (!isDomainAllowed && firstSegment !== "") {
            context.setVariable("security.threat.detected", "INVALID_DOMAIN");
            context.setVariable("security.threat.path", pathSuffix);
            context.setVariable("security.threat.segment", firstSegment);
            context.setVariable("security.threat.ip", clientIp);
            throw new Error("SECURITY: Invalid domain '" + firstSegment + "' not in whitelist");
        }

        // ============================================
        // SECTION 3: SQL INJECTION DETECTION
        // ============================================
        var sqlPatterns = [
            /(\bOR\b|\bAND\b)\s+[\w\d]+\s*=\s*[\w\d]+/i,
            /UNION\s+(ALL\s+)?SELECT/i,
            /DROP\s+(TABLE|DATABASE)/i,
            /INSERT\s+INTO/i,
            /DELETE\s+FROM/i,
            /UPDATE\s+\w+\s+SET/i,
            /--/,
            /\/\*/,
            /;\s*DROP/i,
            /xp_cmdshell/i,
            /exec(\s|\+)+(s|x)p\w+/i
        ];

        var fullUrl = pathSuffix + (queryString ? "?" + queryString : "");

        for (var k = 0; k < sqlPatterns.length; k++) {
            if (sqlPatterns[k].test(fullUrl)) {
                context.setVariable("security.threat.detected", "SQL_INJECTION");
                context.setVariable("security.threat.pattern", sqlPatterns[k].toString());
                context.setVariable("security.threat.url", fullUrl);
                context.setVariable("security.threat.ip", clientIp);
                throw new Error("SECURITY: SQL Injection attempt detected");
            }
        }

        // ============================================
        // SECTION 4: XSS PROTECTION
        // ============================================
        var xssPatterns = [
            /<script[\s\S]*?>/i,
            /javascript:/i,
            /onerror\s*=/i,
            /onload\s*=/i,
            /onclick\s*=/i,
            /<iframe[\s\S]*?>/i,
            /<embed[\s\S]*?>/i,
            /<object[\s\S]*?>/i,
            /eval\s*\(/i,
            /expression\s*\(/i,
            /vbscript:/i,
            /<img[\s\S]*?onerror/i
        ];

        for (var m = 0; m < xssPatterns.length; m++) {
            if (xssPatterns[m].test(fullUrl)) {
                context.setVariable("security.threat.detected", "XSS_ATTEMPT");
                context.setVariable("security.threat.pattern", xssPatterns[m].toString());
                context.setVariable("security.threat.url", fullUrl);
                context.setVariable("security.threat.ip", clientIp);
                throw new Error("SECURITY: XSS attempt detected");
            }
        }

        // ============================================
        // SECTION 5: COMMAND INJECTION PROTECTION
        // ============================================
        var commandInjectionPatterns = [
            /;\s*cat\s+/i,
            /\|\s*ls\s+/i,
            /`.*`/,
            /\$\(.*\)/,
            /&&/,
            /\|\|/,
            />\s*\/dev\/null/i,
            /curl\s+/i,
            /wget\s+/i,
            /nc\s+/i
        ];

        for (var n = 0; n < commandInjectionPatterns.length; n++) {
            if (commandInjectionPatterns[n].test(fullUrl)) {
                context.setVariable("security.threat.detected", "COMMAND_INJECTION");
                context.setVariable("security.threat.pattern", commandInjectionPatterns[n].toString());
                context.setVariable("security.threat.url", fullUrl);
                context.setVariable("security.threat.ip", clientIp);
                throw new Error("SECURITY: Command Injection attempt detected");
            }
        }

        // ============================================
        // SECTION 6: HEADER VALIDATION
        // ============================================
        if (!userAgent || userAgent.length < 5) {
            context.setVariable("security.threat.detected", "MISSING_USER_AGENT");
            context.setVariable("security.threat.ip", clientIp);
            throw new Error("SECURITY: Invalid or missing User-Agent header");
        }

        if ((method === "POST" || method === "PUT")) {
            if (!contentType || contentType.length === 0) {
                context.setVariable("security.threat.detected", "MISSING_CONTENT_TYPE");
                context.setVariable("security.threat.method", method);
                context.setVariable("security.threat.ip", clientIp);
                throw new Error("SECURITY: Missing Content-Type header for " + method + " request");
            }
        }

        var suspiciousUAPatterns = [
            /sqlmap/i, /nikto/i, /nmap/i, /masscan/i, /acunetix/i,
            /nessus/i, /burpsuite/i, /metasploit/i, /havij/i
        ];

        for (var p = 0; p < suspiciousUAPatterns.length; p++) {
            if (suspiciousUAPatterns[p].test(userAgent)) {
                context.setVariable("security.threat.detected", "SUSPICIOUS_USER_AGENT");
                context.setVariable("security.threat.user_agent", userAgent);
                context.setVariable("security.threat.ip", clientIp);
                throw new Error("SECURITY: Suspicious User-Agent detected");
            }
        }

        // ============================================
        // SECTION 7: PATH LENGTH VALIDATION
        // ============================================
        var maxPathLength = 2048;

        if (pathSuffix.length > maxPathLength) {
            context.setVariable("security.threat.detected", "PATH_TOO_LONG");
            context.setVariable("security.threat.path_length", pathSuffix.length.toString());
            context.setVariable("security.threat.ip", clientIp);
            throw new Error("SECURITY: Path length exceeds maximum allowed (" + maxPathLength + " chars)");
        }

        // ============================================
        // SECTION 8: SUSPICIOUS PATTERNS
        // ============================================
        var suspiciousPatterns = [
            /admin/i, /config/i, /\.xml$/i, /\.json$/i, /\.env$/i,
            /\.git/i, /\.svn/i, /backup/i, /phpinfo/i, /test/i, /debug/i
        ];

        for (var q = 0; q < suspiciousPatterns.length; q++) {
            if (suspiciousPatterns[q].test(pathSuffix)) {
                context.setVariable("security.threat.detected", "SUSPICIOUS_PATH");
                context.setVariable("security.threat.pattern", suspiciousPatterns[q].toString());
                context.setVariable("security.threat.path", pathSuffix);
                context.setVariable("security.threat.ip", clientIp);
                throw new Error("SECURITY: Suspicious path pattern detected");
            }
        }

        // ============================================
        // SECTION 9: SUCCESS
        // ============================================
        context.setVariable("security.validated", "true");
        context.setVariable("security.validated.timestamp", Date.now().toString());
        context.setVariable("security.status", "PASSED");
        context.setVariable("security.domain", firstSegment);
        context.setVariable("custom.security.status", "PASSED");
        context.setVariable("custom.security.domain", firstSegment);

    } catch (error) {
        // ============================================
        // SECURITY THREAT DETECTED
        // ============================================
        context.setVariable("security.failed", "true");
        context.setVariable("security.error", error.message);
        context.setVariable("security.raise.fault", "true");
        context.setVariable("custom.security.status", "BLOCKED");
        context.setVariable("custom.security.threat",
            context.getVariable("security.threat.detected") || "UNKNOWN");
        context.setVariable("custom.security.path", pathSuffix);
        context.setVariable("custom.security.ip", clientIp);
        context.setVariable("custom.security.method", method);
        context.setVariable("custom.security.user_agent", userAgent);
    }
}
