import os

c = get_config()
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = int(os.environ.get('JUPYTER_PORT', '8888'))
c.ServerApp.base_url = '/'
c.ServerApp.allow_origin = os.environ.get('JUPYTERHUB_HOST', '*')
c.ServerApp.log_level = 'DEBUG'
c.ServerApp.root_dir = f'/home/{os.environ.get("jovyan", "jovyan")}'
c.ServerApp.open_browser = False
c.ServerApp.token = os.environ.get('JUPYTERHUB_API_TOKEN', '')
