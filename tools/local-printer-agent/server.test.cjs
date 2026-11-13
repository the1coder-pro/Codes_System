const assert = require("node:assert/strict");
const { once } = require("node:events");
const test = require("node:test");
const { createPrinterServer, isAllowedOrigin } = require("./server.cjs");

const token = "test-token-that-is-long-enough-for-unit-tests";
const printers = [
  { name: "Receipt Printer", displayName: "Receipt Printer", isDefault: true },
];

async function withServer(t, overrides = {}) {
  const printed = [];
  const server = createPrinterServer({
    token,
    getPrinters: async () => printers,
    printDocument: async (job) => printed.push(job),
    ...overrides,
  });
  server.listen(0, "127.0.0.1");
  await once(server, "listening");
  t.after(
    () =>
      new Promise((resolve) => {
        server.close(resolve);
        server.closeAllConnections();
      }),
  );
  return { base: `http://127.0.0.1:${server.address().port}`, printed };
}

test("allows localhost and Replit origins but rejects unrelated sites", () => {
  assert.equal(isAllowedOrigin("https://demo.replit.dev"), true);
  assert.equal(isAllowedOrigin("https://demo.replit.app"), true);
  assert.equal(isAllowedOrigin("http://localhost:3000"), true);
  assert.equal(isAllowedOrigin("https://example.com"), false);
});

test("health is public and printer discovery requires the pairing token", async (t) => {
  const { base } = await withServer(t);
  const health = await fetch(`${base}/health`);
  assert.equal(health.status, 200);
  assert.deepEqual(await health.json(), { ok: true });

  const denied = await fetch(`${base}/api/printers`);
  assert.equal(denied.status, 401);
  const listed = await fetch(`${base}/api/printers`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  assert.equal(listed.status, 200);
  assert.equal((await listed.json())[0].isDefault, true);
});

test("preflight permits private-network requests from Replit apps", async (t) => {
  const { base } = await withServer(t);
  const response = await fetch(`${base}/api/printers`, {
    method: "OPTIONS",
    headers: {
      Origin: "https://demo.replit.dev",
      "Access-Control-Request-Method": "GET",
      "Access-Control-Request-Private-Network": "true",
    },
  });
  assert.equal(response.status, 204);
  assert.equal(
    response.headers.get("access-control-allow-private-network"),
    "true",
  );
});

test("silent print accepts only an installed printer and valid job type", async (t) => {
  const { base, printed } = await withServer(t);
  const headers = {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  };
  const response = await fetch(`${base}/api/print`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      printerName: "Receipt Printer",
      jobType: "invoice",
      html: "<html><body>test</body></html>",
    }),
  });
  assert.equal(response.status, 202);
  assert.equal(printed.length, 1);

  const missingPrinter = await fetch(`${base}/api/print`, {
    method: "POST",
    headers,
    body: JSON.stringify({
      printerName: "Missing",
      jobType: "barcode",
      html: "<html></html>",
    }),
  });
  assert.equal(missingPrinter.status, 409);
});
