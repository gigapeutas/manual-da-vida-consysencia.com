#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Config
PHASES=(0 1 2 3 4 5 6 7)
PRODUCTS_PER_PHASE=20

slug_phase() { echo "fase-$1"; }
slug_product() { printf "produto-%02d" "$1"; }

# Root files
mkdir -p _shared/css _shared/js _shared/img

# Global CSS/JS (placeholders)
cat > _shared/css/global.css <<'CSS'
/* ConSySencI.A - Manual da Vida (global) */
:root { color-scheme: light dark; }
html,body{margin:0;padding:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial}
CSS

cat > _shared/js/global.js <<'JS'
// ConSySencI.A - Manual da Vida (global)
(() => { /* no-op */ })();
JS

# Root index (blindado: sem links)
cat > index.html <<'HTML'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="robots" content="noindex,nofollow,noarchive" />
  <title>ConSySencI.A</title>
  <link rel="stylesheet" href="/_shared/css/global.css" />
</head>
<body>
  <script src="/_shared/js/global.js"></script>
</body>
</html>
HTML

# 404
cat > 404.html <<'HTML'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="robots" content="noindex,nofollow,noarchive" />
  <title>404</title>
  <link rel="stylesheet" href="/_shared/css/global.css" />
</head>
<body>
  <script src="/_shared/js/global.js"></script>
</body>
</html>
HTML

# robots.txt (bloqueia indexação de pastas de produtos)
cat > robots.txt <<'TXT'
User-agent: *
Disallow: /fase-0/
Disallow: /fase-1/
Disallow: /fase-2/
Disallow: /fase-3/
Disallow: /fase-4/
Disallow: /fase-5/
Disallow: /fase-6/
Disallow: /fase-7/
Allow: /
TXT

# sitemap.xml (vazio/minimal pra não “entregar” rotas)
cat > sitemap.xml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
</urlset>
XML

# Generate phases and product placeholders
for p in "${PHASES[@]}"; do
  PHASE_DIR="$(slug_phase "$p")"
  mkdir -p "$PHASE_DIR"

  # Phase index (blindado: sem links)
  cat > "$PHASE_DIR/index.html" <<HTML
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="robots" content="noindex,nofollow,noarchive" />
  <title>Fase $p</title>
  <link rel="stylesheet" href="/_shared/css/global.css" />
</head>
<body>
  <script src="/_shared/js/global.js"></script>
</body>
</html>
HTML

  # Products
  for i in $(seq 1 "$PRODUCTS_PER_PHASE"); do
    PROD_SLUG="$(slug_product "$i")"
    mkdir -p "$PHASE_DIR/$PROD_SLUG"
    cat > "$PHASE_DIR/$PROD_SLUG/index.html" <<HTML
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <meta name="robots" content="noindex,nofollow,noarchive" />
  <title>Fase $p - $PROD_SLUG</title>
  <link rel="stylesheet" href="/_shared/css/global.css" />
</head>
<body>
  <script src="/_shared/js/global.js"></script>
</body>
</html>
HTML
  done
done

echo "OK: estrutura criada."
