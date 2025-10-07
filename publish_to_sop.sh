#!/bin/bash
export sop="../../deployment-sops/Deployment/ARC VIIRS Filtered NDVI Processing Chain/arc_viirs_filtered_ndvi"
rsync -r ./docker/ "${sop}"
rsync -r --exclude='*/__pycache__*' \
  ./arc_modape_chain "${sop}"
mkdir -p "${sop}/utils" && cp ./utils/md5hash.py "${sop}/utils"
cp ./wsgi.py "${sop}"
cp ./pyproject.toml "${sop}"
cp ./setup.py "${sop}"
sed -e "s/A_K_I_A/AKIA/g" ./config/production.example.json > "${sop}/production.json"
