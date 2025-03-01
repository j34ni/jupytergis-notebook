import os

CORS_ORIGIN = os.environ.get('JUPYTERHUB_ACTIVITY_URL', '*')
CORS_ORIGIN_HOSTNAME = CORS_ORIGIN.split('://')[1] if '://' in CORS_ORIGIN else CORS_ORIGIN

headers = {
    'X-Frame-Options': 'ALLOWALL',
    'Content-Security-Policy': "; ".join([
        f"default-src 'self' 'unsafe-inline' 'unsafe-eval' https: http: data: blob: {CORS_ORIGIN}",
        f"img-src 'self' data: https: http: blob: *.tile.openstreetmap.org *.tile.opentopomap.org",
        f"connect-src 'self' ws: wss: https: http: *.mapbox.com *.jupytergis.org {CORS_ORIGIN}",
        f"style-src 'self' 'unsafe-inline' https: http: {CORS_ORIGIN}",
        f"script-src 'self' 'unsafe-inline' 'unsafe-eval' https: http: {CORS_ORIGIN}",
        f"frame-src 'self' https: http: {CORS_ORIGIN}"
    ])
}

c = get_config()

c.IPKernelApp.pylab = 'inline'
c.ServerApp.ip = '*'
c.ServerApp.open_browser = False
c.ServerApp.quit_button = False
c.ServerApp.port = 8888
c.ServerApp.base_url = '/'
c.ServerApp.trust_xheaders = True
c.ServerApp.tornado_settings = {
    'static_url_prefix': '/static/',
    'headers': headers
}
c.ServerApp.root_dir = '/home/notebook'
c.ServerApp.allow_origin = CORS_ORIGIN
c.ServerApp.log_level = 'DEBUG'
c.ServerApp.allow_remote_access = True
c.ServerApp.token = os.environ.get('JUPYTERHUB_API_TOKEN', '')
c.InteractiveShell.ast_node_interactivity = "all"
