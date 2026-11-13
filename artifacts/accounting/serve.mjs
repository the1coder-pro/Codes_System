import { createServer, request as httpRequest } from 'node:http';
import { createReadStream, existsSync, statSync } from 'node:fs';
import { resolve, extname, sep } from 'node:path';

const root = resolve(import.meta.dirname, 'dist/public');
const port = Number(process.env.PORT);
const host = process.env.HOST || '0.0.0.0';
if (!port) throw new Error('PORT must be provided by the app workflow.');
const apiPortSetting = process.env.API_PORT;
const apiPort = apiPortSetting ? Number(apiPortSetting) : 0;
if (apiPortSetting && (!Number.isInteger(apiPort) || apiPort <= 0)) {
  throw new Error(`Invalid API_PORT value: "${apiPortSetting}"`);
}
if (apiPort && apiPort === port) {
  throw new Error('API_PORT must be different from PORT.');
}
const mime = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript',
  '.mjs': 'application/javascript',
  '.json': 'application/json',
  '.wasm': 'application/wasm',
  '.css': 'text/css',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.woff2': 'font/woff2',
};

function proxyApiRequest(req, res) {
  const upstream = httpRequest(
    {
      hostname: '127.0.0.1',
      port: apiPort,
      method: req.method,
      path: req.url,
      headers: { ...req.headers, host: `127.0.0.1:${apiPort}` },
    },
    (upstreamRes) => {
      res.writeHead(upstreamRes.statusCode || 502, upstreamRes.headers);
      upstreamRes.pipe(res);
    },
  );

  upstream.on('error', (error) => {
    console.error('Local API proxy failed:', error.message);
    if (res.headersSent) {
      res.destroy(error);
      return;
    }
    res.writeHead(502, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({ error: 'api_unavailable' }));
  });

  req.pipe(upstream);
}

createServer((req, res) => {
  let pathname;
  try {
    pathname = decodeURIComponent(new URL(req.url, 'http://localhost').pathname);
  } catch {
    res.writeHead(400).end('Invalid URL');
    return;
  }
  if (apiPort && (pathname === '/api' || pathname.startsWith('/api/'))) {
    proxyApiRequest(req, res);
    return;
  }
  let file = resolve(root, `.${pathname}`);
  if (file !== root && !file.startsWith(root + sep)) {
    res.writeHead(403).end('Forbidden');
    return;
  }
  if (existsSync(file) && statSync(file).isDirectory()) file = resolve(file, 'index.html');
  if (!existsSync(file)) {
    if (extname(pathname)) {
      res.writeHead(404).end('Not found');
      return;
    }
    file = resolve(root, 'index.html');
  }
  res.writeHead(200, {
    'Content-Type': mime[extname(file)] || 'application/octet-stream',
    'Cache-Control': 'no-cache',
  });
  createReadStream(file).pipe(res);
}).listen(port, host, () => {
  console.info(`Flutter accounting UI serving on ${host}:${port}`);
  if (apiPort) {
    console.info(`Local API proxy enabled for 127.0.0.1:${apiPort}`);
  }
});
