#!/bin/bash

# Use this little script to setup an output directory for running the reproduction script
# within your development container:
cd /var/storage/ \
 && mkdir arc_modape_ndvi \
 && cd arc_modape_ndvi

ln -s /var/modape/modape/scripts/modis_download.py .
ln -s /var/modape/modape/scripts/modis_collect.py .
ln -s /var/modape/modape/scripts/modis_smooth.py .
ln -s /var/modape/modape/scripts/modis_window.py .

# With this setup, you can now run any reproduction script, such as Somalia.sh:
# cd ./development/reproduce/
# ./Somalia.sh