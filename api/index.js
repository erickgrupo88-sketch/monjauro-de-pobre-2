const fs = require('fs');
const path = require('path');
const { URL } = require('url');

const ROOT = path.join(__dirname, '..');
const ORIGIN = 'https://0j386c07.xquiz.io';
const CDN = 'https://cdn.xquiz.co';

function send(res, status, headers, body) {
  res.writeHead(status, headers);
  res.end(body);
}

async function proxy(req, res, base, pathname) {
  try {
    const localImagePrefix = '/images/local/';
    if (base === CDN && pathname.startsWith(localImagePrefix)) {
      const fileName = path.basename(pathname);
      const localPath = path.join(ROOT, 'assets', 'provas-sociais', fileName);
      return fs.readFile(localPath, (err, body) => {
        if (err) {
          return send(res, 404, { 'content-type': 'text/plain; charset=utf-8' }, 'Imagem local nao encontrada');
        }
        send(res, 200, {
          'content-type': 'image/png',
          'cache-control': 'public, max-age=3600',
          'access-control-allow-origin': '*'
        }, body);
      });
    }

    const query = req.url.includes('?') ? '?' + req.url.split('?').slice(1).join('?') : '';
    const target = new URL(pathname + query, base);
    const upstream = await fetch(target, {
      headers: {
        'user-agent': req.headers['user-agent'] || 'Mozilla/5.0',
        'accept': req.headers.accept || '*/*',
        'referer': ORIGIN + '/',
      }
    });
    let body = Buffer.from(await upstream.arrayBuffer());
    let contentType = upstream.headers.get('content-type') || 'application/octet-stream';
    if (base === ORIGIN && contentType.includes('javascript')) {
      body = Buffer.from(body.toString('utf8').replaceAll('https://cdn.xquiz.co', ''), 'utf8');
      contentType = 'text/javascript; charset=utf-8';
    }
    send(res, upstream.status, {
      'content-type': contentType,
      'cache-control': 'public, max-age=3600',
      'access-control-allow-origin': '*'
    }, body);
  } catch (err) {
    send(res, 502, { 'content-type': 'text/plain; charset=utf-8' }, 'Proxy error: ' + err.message);
  }
}

module.exports = async function handler(req, res) {
  const parsed = new URL(req.url, 'https://monjaurodepobre.vercel.app');
  const pathname = decodeURIComponent(parsed.pathname);

  if (pathname.startsWith('/_next/')) return proxy(req, res, ORIGIN, pathname);
  if (pathname === '/favicon.ico') return proxy(req, res, ORIGIN, pathname);
  if (pathname.startsWith('/images/') || pathname.startsWith('/audios/')) return proxy(req, res, CDN, pathname);
  if (pathname.startsWith('/api/') && pathname !== '/api/index.js') {
    return send(res, 200, { 'content-type': 'application/json' }, '{}');
  }

  const htmlPath = path.join(ROOT, 'index.html');
  fs.readFile(htmlPath, 'utf8', (err, html) => {
    if (err) {
      return send(res, 404, { 'content-type': 'text/plain; charset=utf-8' }, 'index.html nao encontrado');
    }
    send(res, 200, {
      'content-type': 'text/html; charset=utf-8',
      'cache-control': 'no-store'
    }, html);
  });
};
