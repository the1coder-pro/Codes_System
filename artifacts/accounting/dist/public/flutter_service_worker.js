'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "d898c7d6944fefa08470247897a5d0b8",
"index.html": "571c9af9d1584dd4f31048b92a8fc092",
"/": "571c9af9d1584dd4f31048b92a8fc092",
"version.json": "4cda3193b10629e56b5f11dc47917096",
"assets/assets/fonts/IBMPlexSansArabic-Regular.ttf": "f36223390481fdcdd0f763436b39c63a",
"assets/assets/fonts/IBMPlexSansArabic-SemiBold.ttf": "ab61f0dde312b4f0b8b11ada99026373",
"assets/assets/fonts/IBMPlexSansArabic-Medium.ttf": "8ec2dc1fde6b217025b23890422f1e70",
"assets/assets/fonts/IBMPlexSansArabic-Bold.ttf": "2e56c2f3563a1cd2b4264ecfca7d4f5a",
"assets/assets/icons/icons8-lock-96.png": "9328c7242045888317621a078c9465f9",
"assets/assets/icons/icons8-printer-96.png": "1249911d9f679b11fc8df905cf1a135e",
"assets/assets/icons/icons8-profit-report-96.png": "a14e606a8d04f0bbbdb88d31f1b9db53",
"assets/assets/icons/icons8-pos-96.png": "ea442e24ffdfe7a83d65a889453ca133",
"assets/assets/icons/icons8-search-96.png": "2b751f509baef56346998b3d5970f055",
"assets/assets/icons/icons8-undo-96.png": "7b54d22866867747d17ed701c33ce358",
"assets/assets/icons/icons8-add-96.png": "8328e1b2e6c90994398284392ef63ed0",
"assets/assets/icons/icons8-exit-96.png": "9eedd67c9f6df1cdf0a22482022bf31e",
"assets/assets/icons/icons8-calculator-96.png": "6b68dfade713f1a061450d656e013b84",
"assets/assets/icons/icons8-edit-96.png": "3f55828f3ec7e205ff28b02edff0e5bd",
"assets/assets/icons/icons8-cash-96.png": "785df24139d0477b2601a60da87838d2",
"assets/assets/icons/icons8-refresh-96.png": "d452fdff020005ab0736df8896c775e6",
"assets/assets/icons/icons8-receipt-96.png": "62a4cfd11f49f491c1b78fa6ec9ba9c4",
"assets/assets/icons/icons8-website-96.png": "e0ce792e9cd6defc95fa52b07a5c5471",
"assets/assets/icons/icons8-remove-properties-96.png": "1c1a66822c41e1d7fecc5d643f69345f",
"assets/assets/icons/icons8-transaction-96.png": "b1277ecb7de235d2d0e4acfd843810f8",
"assets/assets/icons/icons8-users-96.png": "cecb5c142fc895c30a3ccd0f032e50db",
"assets/assets/icons/icons8-test-96.png": "50ffbc5239aaae031820467afb52982b",
"assets/assets/icons/icons8-shopping-cart-96.png": "5cc526bfd1165497c5158c61a01e9e77",
"assets/assets/icons/icons8-save-96.png": "50dd0713ad10fa6e2e8ec83c76b70043",
"assets/assets/icons/icons8-printer-save-96.png": "dc38f3147a4e244bbbbff8592313900c",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "dcbf06143a1057e9493f2453b9100068",
"assets/AssetManifest.bin": "87f91e612f6e061f8110c4e4ca3d8ec0",
"assets/AssetManifest.bin.json": "0cc88c03a4999f658e902d802ef132a4",
"assets/FontManifest.json": "3e7d76fd8a6eb1dd2abc4bf170097507",
"assets/NOTICES": "9d26c0c76a5c8739a0e2d55373dee6d2",
"assets/packages/fluent_ui/assets/AcrylicNoise.png": "81f27726c45346351eca125bd062e9a7",
"assets/packages/fluent_ui/fonts/FluentIcons.ttf": "f3c4f09a37ace3246250ff7142da5cdd",
"assets/fonts/MaterialIcons-Regular.otf": "33b83fa4e59d5e67b655b67b408d1d72",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"main.dart.js": "e88c59f091814212269d5c5e82fb41cb",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"manifest.json": "110125939368de3a26f1b0cf05633ac6"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
