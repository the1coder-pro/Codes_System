const http = require("node:http");
const { URL } = require("node:url");

const BODY_LIMIT = 4 * 1024 * 1024;

function isAllowedOrigin(origin, extraOrigins = []) {
  if (!origin) return false;
  if (extraOrigins.includes(origin)) return true;

  try {
    const url = new URL(origin);
    const hostname = url.hostname.toLowerCase();
    if (
      (url.protocol === "http:" || url.protocol === "https:") &&
      ["localhost", "127.0.0.1", "::1"].includes(hostname)
    ) {
      return true;
    }
    return (
      url.protocol === "https:" &&
      (hostname.endsWith(".replit.dev") ||
        hostname.endsWith(".replit.app"))
    );
  } catch {
    return false;
  }
}

function sendJson(response, status, body) {
  response.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    "cache-control": "no-store",
  });
  response.end(JSON.stringify(body));
}

function readJson(request) {
  return new Promise((resolve, reject) => {
    let size = 0;
    const chunks = [];
    request.on("data", (chunk) => {
      size += chunk.length;
      if (size > BODY_LIMIT) {
        reject(Object.assign(new Error("request_too_large"), { status: 413 }));
        request.destroy();
        return;
      }
      chunks.push(chunk);
    });
    request.on("end", () => {
      try {
        resolve(JSON.parse(Buffer.concat(chunks).toString("utf8")));
      } catch {
        reject(Object.assign(new Error("invalid_json"), { status: 400 }));
      }
    });
    request.on("error", reject);
  });
}

function hasValidToken(request, token) {
  const header = request.headers.authorization || "";
  return header === `Bearer ${token}`;
}

function createPrinterServer({
  token,
  getPrinters,
  printDocument,
  extraOrigins = [],
  logger = { error: () => {} },
}) {
  if (!token || typeof getPrinters !== "function") {
    throw new TypeError("token and getPrinters are required");
  }

  return http.createServer(async (request, response) => {
    const origin = request.headers.origin;
    if (origin) {
      if (!isAllowedOrigin(origin, extraOrigins)) {
        sendJson(response, 403, { error: "origin_not_allowed" });
        return;
      }
      response.setHeader("access-control-allow-origin", origin);
      response.setHeader("vary", "Origin");
      response.setHeader(
        "access-control-allow-headers",
        "Authorization, Content-Type",
      );
      response.setHeader("access-control-allow-methods", "GET, POST, OPTIONS");
      response.setHeader("access-control-allow-private-network", "true");
    }

    if (request.method === "OPTIONS") {
      response.writeHead(204);
      response.end();
      return;
    }

    const url = new URL(request.url || "/", "http://127.0.0.1");
    if (request.method === "GET" && url.pathname === "/health") {
      sendJson(response, 200, { ok: true });
      return;
    }

    if (url.pathname.startsWith("/api/") && !hasValidToken(request, token)) {
      sendJson(response, 401, { error: "unauthorized" });
      return;
    }

    if (request.method === "GET" && url.pathname === "/api/printers") {
      try {
        const printers = await getPrinters();
        sendJson(
          response,
          200,
          printers.map((printer) => ({
            name: printer.name,
            displayName: printer.displayName || printer.name,
            description: printer.description || "",
            isDefault: printer.isDefault === true,
          })),
        );
      } catch (error) {
        logger.error(error);
        sendJson(response, 503, { error: "printer_discovery_failed" });
      }
      return;
    }

    if (request.method === "POST" && url.pathname === "/api/print") {
      if (typeof printDocument !== "function") {
        sendJson(response, 503, { error: "printing_unavailable" });
        return;
      }
      let job;
      try {
        job = await readJson(request);
      } catch (error) {
        sendJson(response, error.status || 400, {
          error: error.message || "invalid_request",
        });
        return;
      }

      const printerName =
        typeof job.printerName === "string" ? job.printerName.trim() : "";
      const html = typeof job.html === "string" ? job.html : "";
      if (
        !printerName ||
        !html ||
        !["invoice", "barcode"].includes(job.jobType)
      ) {
        sendJson(response, 400, { error: "invalid_print_job" });
        return;
      }
      try {
        const printers = await getPrinters();
        if (!printers.some((printer) => printer.name === printerName)) {
          sendJson(response, 409, { error: "printer_not_found" });
          return;
        }
        await printDocument({ html, printerName, jobType: job.jobType });
        sendJson(response, 202, { ok: true });
      } catch (error) {
        logger.error(error);
        sendJson(response, 500, { error: "print_failed" });
      }
      return;
    }

    sendJson(response, 404, { error: "not_found" });
  });
}

module.exports = { createPrinterServer, isAllowedOrigin };
