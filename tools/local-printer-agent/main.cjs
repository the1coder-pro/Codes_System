const crypto = require("node:crypto");
const fs = require("node:fs");
const fsp = require("node:fs/promises");
const path = require("node:path");
const { app, BrowserWindow } = require("electron");
const { createPrinterServer } = require("./server.cjs");

const PORT = Number(process.env.PRINTER_SERVICE_PORT || 17863);
let printWindow;
let server;
let printQueue = Promise.resolve();

function loadToken() {
  const folder = app.getPath("userData");
  const configPath = path.join(folder, "printer-agent.json");
  fs.mkdirSync(folder, { recursive: true });
  try {
    const config = JSON.parse(fs.readFileSync(configPath, "utf8"));
    if (typeof config.token === "string" && config.token.length >= 40) {
      return config.token;
    }
  } catch {}

  const token = crypto.randomBytes(32).toString("hex");
  fs.writeFileSync(configPath, JSON.stringify({ token }, null, 2), {
    mode: 0o600,
  });
  return token;
}

function addPrintSecurityPolicy(html) {
  const policy =
    '<meta http-equiv="Content-Security-Policy" content="default-src \'none\'; img-src data: blob:; style-src \'unsafe-inline\'; font-src data:;">';
  if (/<head(?:\s[^>]*)?>/i.test(html)) {
    return html.replace(/<head(?:\s[^>]*)?>/i, (head) => `${head}${policy}`);
  }
  return `<!doctype html><html><head>${policy}</head><body>${html}</body></html>`;
}

async function printHtml({ html, printerName }) {
  const run = printQueue.then(async () => {
    const securedHtml = addPrintSecurityPolicy(html);
    const temporaryFile = path.join(
      app.getPath("temp"),
      `accounting-print-${crypto.randomBytes(12).toString("hex")}.html`,
    );
    await fsp.writeFile(temporaryFile, securedHtml, { mode: 0o600 });
    try {
      await printWindow.loadFile(temporaryFile);
      await new Promise((resolve, reject) => {
        printWindow.webContents.print(
          {
            silent: true,
            deviceName: printerName,
            printBackground: true,
            color: true,
          },
          (success, failureReason) => {
            if (success) resolve();
            else reject(new Error(failureReason || "print_failed"));
          },
        );
      });
    } finally {
      await fsp.unlink(temporaryFile).catch(() => {});
      await printWindow.loadURL("about:blank").catch(() => {});
    }
  });
  printQueue = run.catch(() => {});
  return run;
}

async function start() {
  const token = loadToken();
  if (process.argv.includes("--show-token")) {
    process.stdout.write(`Pairing token: ${token}\n`);
  }

  printWindow = new BrowserWindow({
    show: false,
    webPreferences: {
      contextIsolation: true,
      javascript: false,
      nodeIntegration: false,
      sandbox: true,
    },
  });
  printWindow.webContents.setWindowOpenHandler(() => ({ action: "deny" }));
  await printWindow.loadURL("about:blank");

  const extraOrigins = (process.env.PRINTER_ALLOWED_ORIGINS || "")
    .split(",")
    .map((origin) => origin.trim())
    .filter(Boolean);
  server = createPrinterServer({
    token,
    extraOrigins,
    getPrinters: async () =>
      (await printWindow.webContents.getPrintersAsync()).map((printer) => ({
        name: printer.name,
        displayName: printer.displayName,
        description: printer.description,
        isDefault: printer.isDefault,
      })),
    printDocument: printHtml,
    logger: { error: (error) => process.stderr.write(`${error.message}\n`) },
  });
  server.listen(PORT, "127.0.0.1", () => {
    process.stdout.write(`Local printer service ready on 127.0.0.1:${PORT}\n`);
    if (process.env.PRINTER_SERVICE_PORT && Number(process.env.PRINTER_SERVICE_PORT) !== PORT) {
      process.stderr.write("PRINTER_SERVICE_PORT must be a valid port number.\n");
    }
  });
}

app.whenReady().then(() => {
  if (app.dock) app.dock.hide();
  start().catch((error) => {
    process.stderr.write(`Printer service failed: ${error.message}\n`);
    app.quit();
  });
});

app.on("before-quit", () => {
  server?.close();
  if (printWindow && !printWindow.isDestroyed()) printWindow.destroy();
});
