FROM ghost:6-alpine

# Metadata
LABEL description="Ghost CMS deployment (Render + Aiven + Brevo)"

# Set working directory
WORKDIR /var/lib/ghost

# Bake custom themes into the image so they survive redeploys.
# Render's free tier has an ephemeral filesystem - themes uploaded
# via Ghost Admin only live on disk and are lost on every redeploy.
# Baking them into the image (and the Dockerfile) keeps them persistent.
COPY themes/headline /var/lib/ghost/content/themes/headline

# Bake seed content (logo, icon, post covers, etc.) into the image for the
# same reason. Images uploaded via Ghost Admin are lost on redeploy;
# committing them to this repo and copying them here keeps them
# persistent across deploys.
COPY content-seed/images /var/lib/ghost/content/images

# Same problem, same fix, for site-wide settings files (routes.yaml).
# Settings → Labs uploads also only live on the ephemeral disk and are
# lost on redeploy/restart - baking the file in keeps custom routes
# (e.g. /startups/, /weekly-vc-report/) working across restarts.
COPY content-seed/settings /var/lib/ghost/content/settings

# Expose Ghost port
EXPOSE 2368

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:2368/ghost/api/v3/admin/site/', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start Ghost
CMD ["node", "current/index.js"]
