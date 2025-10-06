#!/bin/bash
export sop="../../deployment-sops/Deployment/ARC VIIRS Filtered NDVI Processing Chain/arc_viirs_filtered_ndvi"
rsync -r ./docker/ "${sop}"
rsync -r --exclude='*/__pycache__*' \
  ./arc_modape_chain "${sop}"
cp ./wsgi.py "${sop}"
cp ./pyproject.toml "${sop}"
cp ./setup.py "${sop}"
cp ./config/production.example.json "${sop}/production.json"
