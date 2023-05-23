FROM ghcr.io/3kmfi6hp/argo-airport-paas:main

# 健康检查
HEALTHCHECK --interval=1m --timeout=30s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000
