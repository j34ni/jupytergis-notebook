import os

CORS_ORIGIN = '*'
CORS_ORIGIN_HOSTNAME = '*'

if os.environ['CORS_ORIGIN'] != 'none':
    CORS_ORIGIN = os.environ.get('CORS_ORIGIN', '')
    CORS_ORIGIN_HOSTNAME = CORS_ORIGIN.split('://')[1]

headers = {
    'X-Frame-Options': 'ALLOWALL',
    'Content-Security-Policy':
        "; ".join([
            f"default-src 'self' https: {CORS_ORIGIN}",
            f"img-src 'self' data: *",
            f"connect-src 'self' wss://{CORS_ORIGIN_HOSTNAME}",
            f"style-src 'unsafe-inline' 'self' {CORS_ORIGIN}",
            f"script-src https: 'unsafe-inline' 'unsafe-eval' 'self' {CORS_ORIGIN}"
        ])
}

c = get_config()

c.IPKernelApp.pylab = 'inline'
c.ServerApp.ip = '*'
#c.ServerApp.quit_button = False
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888
c.ServerApp.notebook_dir = os.environ['HOME']
c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True
c.ServerApp.token = ''
c.ServerApp.password = ''
# Run all nodes interactively
c.InteractiveShell.ast_node_interactivity = "all"

c.ServerApp.allow_credentials = True
c.ServerApp.allow_root = True
