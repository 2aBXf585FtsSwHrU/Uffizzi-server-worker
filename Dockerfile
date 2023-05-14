FROM ghcr.io/3kmfi6hp/argo-airport-paas:main

# 健康检查
HEALTHCHECK --interval=2m --timeout=30s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80
# 健康检查
HEALTHCHECK --interval=2m --timeout=30s \
  CMD wget --no-verbose --tries=1 --spider ${UFFIZZI_PREDICTABLE_URL}
