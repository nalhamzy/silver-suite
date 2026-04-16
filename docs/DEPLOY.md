# Deploying this site to GitHub Pages

The `docs/` folder is a static site — landing, privacy, terms — served
directly by GitHub Pages.

## One-time setup

1. Push to GitHub as `https://github.com/nalhamzy/silver-suite`.
2. **Repo → Settings → Pages**
   - **Source**: Deploy from a branch
   - **Branch**: `main` → Folder: `/docs`
3. Save. ~60s to publish.
4. Confirm at `https://nalhamzy.github.io/silver-suite/`.
5. Paste into App Store Connect / Play Console:
   - Support: `.../silver-suite/#support`
   - Marketing: `.../silver-suite/`
   - Privacy: `.../silver-suite/privacy.html`

## Updates

Any push to `main` touching `/docs/` auto-publishes. No build step.

## Custom domain (optional)

Add a `CNAME` file inside `docs/` with `silversuite.app` (or similar),
set Pages → Custom domain to match, configure DNS per GitHub docs,
enforce HTTPS.

## Local preview

`.nojekyll` disables Jekyll. Open `docs/index.html` directly, or run
`python -m http.server 8000` inside `docs/`.
