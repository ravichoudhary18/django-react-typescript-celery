# This ensures the Celery app is loaded when Django starts
from .celery_config import app as celery_app

__all__ = ("celery_app",)
