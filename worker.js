export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const path = url.pathname.replace(/\/+$/, ""); 


    const escapeHtml = str =>
      String(str)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;");

    // Helper: get R2 object by key
    async function getFlagResponse(countryCode) {
      const key = `${countryCode.toUpperCase()}.svg`; 
      const obj = await env.FLAGS_BUCKET.get(key);

      if (!obj) {
        return new Response("Flag not found", { status: 404 });
      }

      return new Response(obj.body, {
        headers: {
          "content-type": obj.httpMetadata?.contentType || "image/svg+xml",
          "cache-control": "public, max-age=86400",
        },
      });
    }

   
    const countryMatch = path.match(/^\/secure\/([A-Za-z]{2})$/i);
    if (countryMatch) {
      const cc = countryMatch[1].toUpperCase();
      return await getFlagResponse(cc);
    }

    
    if (path === "/secure" || path === "") {
      const email = request.headers.get("Cf-Access-Authenticated-User-Email") || "unknown@example.com";
      const country = (request.headers.get("CF-IPCountry") || "UN").toUpperCase();
      const timestamp = new Date().toISOString();

      const html = `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>Identity Info</title>
    <style>
      body { font-family: system-ui, -apple-system, "Segoe UI", Roboto, Arial; text-align:center; padding:3rem; }
      a.country { color:#0a66c2; text-decoration:none; font-weight:600; }
    </style>
  </head>
  <body>
    <h2>${escapeHtml(email)} authenticated at ${escapeHtml(timestamp)} from
      <a class="country" href="/secure/${escapeHtml(country)}">${escapeHtml(country)}</a>
    </h2>
  </body>
</html>`;

      return new Response(html, {
        headers: { "content-type": "text/html; charset=utf-8" },
      });
    }

    
    return new Response("Not found", { status: 404 });
  },
};

