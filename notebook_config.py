import os

c = get_config()
c.ServerApp.ip = '0.0.0.0'  # Listen on all interfaces
c.ServerApp.open_browser = False
c.ServerApp.port = 8888
c.ServerApp.base_url = '/'  # Open OnDemand will proxy this
c.ServerApp.allow_origin = os.environ.get('JUPYTERHUB_HOST', '*')  # Dynamic from JupyterHub
c.ServerApp.log_level = 'DEBUG'
c.ServerApp.root_dir = '/home/jovyan'  # Generic working directory
c.ServerApp.token = os.environ.get('JUPYTERHUB_API_TOKEN', '')  # Handle JupyterHub token
