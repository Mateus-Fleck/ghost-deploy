FROM ghost:6-alpine

# Metadata
LABEL maintainer="WarZ Tech News <tech@warztech.news>"
LABEL description="Ghost CMS for WarZ Tech News"

# Set working directory
WORKDIR /var/lib/ghost

# Expose Ghost port
EXPOSE 2368

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:2368/ghost/api/v3/admin/site/', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start Ghost
CMD ["node", "current/index.js"]
