# Configuration file for ipython-notebook.

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

# ------------------------------------------------------------------------------
# NotebookApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.ServerApp.ip = '*'
c.ServerApp.open_browser = False
c.ServerApp.quit_button = False
c.ServerApp.port = 8888
c.ServerApp.base_url = '/'
c.ServerApp.trust_xheaders = True
c.ServerApp.tornado_settings = {'static_url_prefix': '/static/'}
c.ServerApp.root_dir = '/home/notebook'
c.ServerApp.allow_origin = '*'
c.ServerApp.log_level = 'DEBUG'
c.ServerApp.allow_remote_access = True
c.InteractiveShell.ast_node_interactivity = "all"
