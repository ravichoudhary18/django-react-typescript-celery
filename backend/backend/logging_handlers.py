import logging.handlers
import lzma
import os
import shutil


class CompressedTimedRotatingFileHandler(logging.handlers.TimedRotatingFileHandler):
    def __init__(
        self,
        filename,
        when="midnight",
        interval=1,
        backupCount=0,
        encoding=None,
        delay=False,
        utc=False,
        atTime=None,
        errors=None,
        archive_dir="/mnt/archives",
    ):
        super().__init__(
            filename, when, interval, backupCount, encoding, delay, utc, atTime, errors
        )
        self.archive_dir = archive_dir
        # Ensure archive directory exists
        if not os.path.exists(self.archive_dir):
            os.makedirs(self.archive_dir)
        # Set custom rotator
        self.rotator = self._compress_rotator

    def _compress_rotator(self, source, dest):
        # Compute the compressed destination in the archive folder
        base_name = os.path.basename(dest)  # e.g., 'app.log.2025-09-26'
        compressed_dest = os.path.join(self.archive_dir, base_name + ".xz")

        # Compress the source file to the archive
        with open(source, "rb") as f_in:
            with lzma.open(compressed_dest, "wb") as f_out:
                shutil.copyfileobj(f_in, f_out)

        # Remove the original uncompressed source
        os.remove(source)
