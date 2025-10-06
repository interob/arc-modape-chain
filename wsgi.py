"""
Run as Gunicorn service from within the container: gunicorn --workers=1 --threads=1 --bind 0.0.0.0:5001 'wsgi:arc_modape_chain("production.json")'
"""

from arc_modape_chain.arc_modape_chain import app_setup as arc_modape_chain  # noqa: F401
