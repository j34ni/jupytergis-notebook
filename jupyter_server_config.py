import os
# Configuration file for ipython-notebook.

c = get_config()

# Set JUPYTERHUB_SERVICE_URL to localhost if not already defined
if 'JUPYTERHUB_SERVICE_URL' not in os.environ:
    os.environ['JUPYTERHUB_SERVICE_URL'] = 'http://localhost:8888'

# Default setting for CORS
CORS_ORIGIN = '*'
CORS_ORIGIN_HOSTNAME = '*'

# Check if CORS_ORIGIN is set in the environment and is not 'none'
if 'CORS_ORIGIN' in os.environ and os.environ['CORS_ORIGIN'].lower() != 'none':
    CORS_ORIGIN = os.environ['CORS_ORIGIN']
    # Extract hostname only if CORS_ORIGIN is a valid URL
    if '://' in CORS_ORIGIN:
        CORS_ORIGIN_HOSTNAME = CORS_ORIGIN.split('://')[1]
    else:
        CORS_ORIGIN_HOSTNAME = CORS_ORIGIN
else:
    # If you want to default to localhost when no valid CORS_ORIGIN is provided
    # Comment this out if you want to keep the '*' default
    CORS_ORIGIN = 'http://localhost'
    CORS_ORIGIN_HOSTNAME = 'localhost'

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

# ------------------------------------------------------------------------------
# ServerApp configuration
# ------------------------------------------------------------------------------

c.IPKernelApp.pylab = 'inline'
c.ServerApp.ip = '*'
c.ServerApp.quit_button = False
c.ServerApp.port = 8888
c.ServerApp.notebook_dir = os.environ['HOME']
c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True
c.ServerApp.token = ''
c.ServerApp.password = ''
# Run all nodes interactively
c.InteractiveShell.ast_node_interactivity = "all"
