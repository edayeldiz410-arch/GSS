const CACHE_NAME = 'paiements-v1';
const PRECACHE = [
  '/paiements/',
  '/static/vendor/js/html2pdf.bundle.min.js',
  '/static/vendor/js/qrcode.min.js',
  '/static/school_logo.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(PRECACHE)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => Promise.all(keys.map((k) => { if (k !== CACHE_NAME) return caches.delete(k); }))).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  const url = new URL(event.request.url);

  // For navigation to the paiements page, serve cached shell when offline
  if (event.request.mode === 'navigate' || url.pathname === '/paiements/') {
    event.respondWith(
      fetch(event.request).then((resp) => {
        // update cache
        const copy = resp.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
        return resp;
      }).catch(() => caches.match('/paiements/'))
    );
    return;
  }

  // For API GETs or static assets: network first, fallback to cache
  if (url.pathname.startsWith('/api/') || url.pathname.startsWith('/static/')) {
    event.respondWith(
      fetch(event.request).then((resp) => {
        try { if (resp && resp.status === 200) { const copy = resp.clone(); caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy)); } }catch(e){}
        return resp;
      }).catch(() => caches.match(event.request))
    );
    return;
  }

  // Default: cache first, then network
  event.respondWith(
    caches.match(event.request).then((cached) => cached || fetch(event.request).then((resp) => {
      try { const copy = resp.clone(); caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy)); }catch(e){}
      return resp;
    }).catch(() => caches.match('/paiements/')))
  );
});
