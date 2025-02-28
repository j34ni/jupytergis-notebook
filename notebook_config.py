import os

CORS_ORIGIN = '*'
CORS_ORIGIN_HOSTNAME = '*'

if os.environ.get('CORS_ORIGIN', 'none') != 'none':
    CORS_ORIGIN = os.environ.get('CORS_ORIGIN', '')
    CORS_ORIGIN_HOSTNAME = CORS_ORIGIN.split('://')[1] if '://' in CORS_ORIGIN else CORS_ORIGIN

headers = {
    'X-Frame-Options': 'ALLOWALL',
    'Content-Security-Policy': "; ".join([
        f"default-src 'self' https: {CORS_ORIGIN}",
        "img-src 'self' data: https: blob:",
        f"connect-src 'self' ws: wss: {CORS_ORIGIN_HOSTNAME}",
        f"style-src 'self' 'unsafe-inline' {CORS_ORIGIN}",
        f"script-src 'self' 'unsafe-inline' 'unsafe-eval' https: {CORS_ORIGIN}" 
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
c.ServerApp.allow_origin = '*'
c.ServerApp.log_level = 'DEBUG'
c.ServerApp.allow_remote_access = True
c.InteractiveShell.ast_node_interactivity = "all"
