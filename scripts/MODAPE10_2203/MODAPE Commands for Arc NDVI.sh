#!/bin/bash
if [ ! -d "/var/modape" ] 
then
  cd /var
  git clone https://github.com/WFP-VAM/modape.git
  cd modape && git checkout tags/v1.2.0 -b modape-v1.2.0
  pip install .
fi
if [ ! -d "/var/storage/MODAPE10_LSO_2203_LSO" ]
then
  mkdir /var/storage/MODAPE10_LSO_2203_LSO
fi
cd /var/storage/MODAPE10_LSO_2203_LSO
rm -f *.hdf
rm -f *.h5
rm -f *.modapedl
export AFRICA_TILES="h15v07,h16v06,h16v07,h16v08,h17v05,h17v06,h17v07,h17v08,\
h18v05,h18v06,h18v07,h18v08,h18v09,h19v05,h19v06,h19v07,h19v08,h19v09,\
h19v10,h19v11,h19v12,h20v05,h20v06,h20v07,h20v08,h20v09,h20v10,h20v11,\
h20v12,h21v05,h21v06,h21v07,h21v08,h21v09,h21v10,h21v11,h22v07,h22v08,\
h22v09,h22v10,h22v11,h23v07,h23v08,h23v09,h23v10,h23v11"
export TILES="h20v11,h20v12"
export CMR_USERNAME=<NASA CMR login username>
export CMR_PASSWORD=<NASA CMR login password>
resuming_from=$(python << END
from pathlib import Path
from modape.modis import ModisSmoothH5
last_collected = set()
for rawfile in [str(x) for x in Path('./VIM').glob("*.h5")]:
  smt_h5 = ModisSmoothH5(str(rawfile), '')
  last_collected.add(smt_h5.last_collected)

print(''.join(last_collected))
END
)
if [[ $resuming_from =~ ^[[:space:]]*$ ]]
then
  # B1-4: Download 64 timesteps back from 2025-10d3 (#30):
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $AFRICA_TILES -b 2024-06-09 -e 2024-06-09 
  modis_collect --interleave --cleanup --tiles-required $TILES .
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2024-06-17 -e 2025-10-24 
  modis_collect --interleave --cleanup .
  resuming_from="2025297"
else
  echo "--------------------------------------------"
  echo "Resuming processing from: $resuming_from"
  echo "--------------------------------------------"
fi

if [ $resuming_from -le 2025297 ]
then
  # B5: Import locally optimized smoothing grid:
  modis_smooth --tempint 10 \
    --sgrid MODAPE10_LSO_2203_SGrid.tif \
    -d /var/storage/MODAPE10_LSO_2203_LSO/VIM/SMOOTH \
    /var/storage/MODAPE10_LSO_2203_LSO/VIM
fi

# C: Processing of 2025-OTD#39 (2025-11-01;DOY=305)
if [ $resuming_from -le 2025297 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-11-01 -e 2025-11-01 
  modis_collect --interleave --cleanup --last-collected 2025297 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025305 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-11d1 (#31)
  modis_window -b 2025-11-05 -e 2025-11-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-10d3 (#30)
  modis_window -b 2025-10-25 -e 2025-10-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#40 (2025-11-09;DOY=313)
if [ $resuming_from -le 2025305 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-11-09 -e 2025-11-09 
  modis_collect --interleave --cleanup --last-collected 2025305 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025313 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-11d2 (#32)
  modis_window -b 2025-11-15 -e 2025-11-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-11d1 (#31)
  modis_window -b 2025-11-05 -e 2025-11-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-10d3 (#30)
  modis_window -b 2025-10-25 -e 2025-10-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#41 (2025-11-17;DOY=321)
if [ $resuming_from -le 2025313 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-11-17 -e 2025-11-17 
  modis_collect --interleave --cleanup --last-collected 2025313 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025321 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-11d2 (#32)
  modis_window -b 2025-11-15 -e 2025-11-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-11d1 (#31)
  modis_window -b 2025-11-05 -e 2025-11-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#42 (2025-11-25;DOY=329)
if [ $resuming_from -le 2025321 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-11-25 -e 2025-11-25 
  modis_collect --interleave --cleanup --last-collected 2025321 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025329 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-11d3 (#33)
  modis_window -b 2025-11-25 -e 2025-11-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-11d2 (#32)
  modis_window -b 2025-11-15 -e 2025-11-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#43 (2025-12-03;DOY=337)
if [ $resuming_from -le 2025329 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-12-03 -e 2025-12-03 
  modis_collect --interleave --cleanup --last-collected 2025329 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025337 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-12d1 (#34)
  modis_window -b 2025-12-05 -e 2025-12-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-11d3 (#33)
  modis_window -b 2025-11-25 -e 2025-11-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#44 (2025-12-11;DOY=345)
if [ $resuming_from -le 2025337 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-12-11 -e 2025-12-11 
  modis_collect --interleave --cleanup --last-collected 2025337 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025345 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-12d2 (#35)
  modis_window -b 2025-12-15 -e 2025-12-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-12d1 (#34)
  modis_window -b 2025-12-05 -e 2025-12-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-11d3 (#33)
  modis_window -b 2025-11-25 -e 2025-11-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#45 (2025-12-19;DOY=353)
if [ $resuming_from -le 2025345 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-12-19 -e 2025-12-19 
  modis_collect --interleave --cleanup --last-collected 2025345 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025353 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-12d3 (#36)
  modis_window -b 2025-12-25 -e 2025-12-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-12d2 (#35)
  modis_window -b 2025-12-15 -e 2025-12-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-12d1 (#34)
  modis_window -b 2025-12-05 -e 2025-12-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#46 (2025-12-27;DOY=361)
if [ $resuming_from -le 2025353 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-12-27 -e 2025-12-27 
  modis_collect --interleave --cleanup --last-collected 2025353 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025361 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-12d3 (#36)
  modis_window -b 2025-12-25 -e 2025-12-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-12d2 (#35)
  modis_window -b 2025-12-15 -e 2025-12-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#01 (2026-01-01;DOY=1)
if [ $resuming_from -le 2025361 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-01-01 -e 2026-01-01 
  modis_collect --interleave --cleanup --last-collected 2025361 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026001 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-01d1 (#01)
  modis_window -b 2026-01-05 -e 2026-01-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-12d3 (#36)
  modis_window -b 2025-12-25 -e 2025-12-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#02 (2026-01-09;DOY=9)
if [ $resuming_from -le 2026001 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-01-09 -e 2026-01-09 
  modis_collect --interleave --cleanup --last-collected 2026001 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2026009 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-01d2 (#02)
  modis_window -b 2026-01-15 -e 2026-01-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-01d1 (#01)
  modis_window -b 2026-01-05 -e 2026-01-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#03 (2026-01-17;DOY=17)
if [ $resuming_from -le 2026009 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-01-17 -e 2026-01-17 
  modis_collect --interleave --cleanup --last-collected 2026009 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026017 -d ./VIM/SMOOTH ./VIM
  # CS1: 2026-01d2 (#02)
  modis_window -b 2026-01-15 -e 2026-01-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-01d1 (#01)
  modis_window -b 2026-01-05 -e 2026-01-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#04 (2026-01-25;DOY=25)
if [ $resuming_from -le 2026017 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-01-25 -e 2026-01-25 
  modis_collect --interleave --cleanup --last-collected 2026017 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026025 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-01d3 (#03)
  modis_window -b 2026-01-25 -e 2026-01-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-01d2 (#02)
  modis_window -b 2026-01-15 -e 2026-01-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#05 (2026-02-02;DOY=33)
if [ $resuming_from -le 2026025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-02-02 -e 2026-02-02 
  modis_collect --interleave --cleanup --last-collected 2026025 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2026033 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-02d1 (#04)
  modis_window -b 2026-02-05 -e 2026-02-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-01d3 (#03)
  modis_window -b 2026-01-25 -e 2026-01-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#06 (2026-02-10;DOY=41)
if [ $resuming_from -le 2026033 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-02-10 -e 2026-02-10 
  modis_collect --interleave --cleanup --last-collected 2026033 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026041 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-02d2 (#05)
  modis_window -b 2026-02-15 -e 2026-02-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-02d1 (#04)
  modis_window -b 2026-02-05 -e 2026-02-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-01d3 (#03)
  modis_window -b 2026-01-25 -e 2026-01-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#07 (2026-02-18;DOY=49)
if [ $resuming_from -le 2026041 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-02-18 -e 2026-02-18 
  modis_collect --interleave --cleanup --last-collected 2026041 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026049 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-02d3 (#06)
  modis_window -b 2026-02-25 -e 2026-02-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-02d2 (#05)
  modis_window -b 2026-02-15 -e 2026-02-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-02d1 (#04)
  modis_window -b 2026-02-05 -e 2026-02-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#08 (2026-02-26;DOY=57)
if [ $resuming_from -le 2026049 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-02-26 -e 2026-02-26 
  modis_collect --interleave --cleanup --last-collected 2026049 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026057 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-03d1 (#07)
  modis_window -b 2026-03-05 -e 2026-03-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-02d3 (#06)
  modis_window -b 2026-02-25 -e 2026-02-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-02d2 (#05)
  modis_window -b 2026-02-15 -e 2026-02-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#09 (2026-03-06;DOY=65)
if [ $resuming_from -le 2026057 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-03-06 -e 2026-03-06 
  modis_collect --interleave --cleanup --last-collected 2026057 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026065 -d ./VIM/SMOOTH ./VIM
  # CS1: 2026-03d1 (#07)
  modis_window -b 2026-03-05 -e 2026-03-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-02d3 (#06)
  modis_window -b 2026-02-25 -e 2026-02-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#10 (2026-03-14;DOY=73)
if [ $resuming_from -le 2026065 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-03-14 -e 2026-03-14 
  modis_collect --interleave --cleanup --last-collected 2026065 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026073 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-03d2 (#08)
  modis_window -b 2026-03-15 -e 2026-03-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-03d1 (#07)
  modis_window -b 2026-03-05 -e 2026-03-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#11 (2026-03-22;DOY=81)
if [ $resuming_from -le 2026073 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-03-22 -e 2026-03-22 
  modis_collect --interleave --cleanup --last-collected 2026073 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2026081 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-03d3 (#09)
  modis_window -b 2026-03-25 -e 2026-03-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-03d2 (#08)
  modis_window -b 2026-03-15 -e 2026-03-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#12 (2026-03-30;DOY=89)
if [ $resuming_from -le 2026081 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-03-30 -e 2026-03-30 
  modis_collect --interleave --cleanup --last-collected 2026081 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026089 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-04d1 (#10)
  modis_window -b 2026-04-05 -e 2026-04-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-03d3 (#09)
  modis_window -b 2026-03-25 -e 2026-03-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-03d2 (#08)
  modis_window -b 2026-03-15 -e 2026-03-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#13 (2026-04-07;DOY=97)
if [ $resuming_from -le 2026089 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-04-07 -e 2026-04-07 
  modis_collect --interleave --cleanup --last-collected 2026089 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026097 -d ./VIM/SMOOTH ./VIM
  # CS1: 2026-04d1 (#10)
  modis_window -b 2026-04-05 -e 2026-04-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-03d3 (#09)
  modis_window -b 2026-03-25 -e 2026-03-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#14 (2026-04-15;DOY=105)
if [ $resuming_from -le 2026097 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-04-15 -e 2026-04-15 
  modis_collect --interleave --cleanup --last-collected 2026097 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026105 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-04d2 (#11)
  modis_window -b 2026-04-15 -e 2026-04-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-04d1 (#10)
  modis_window -b 2026-04-05 -e 2026-04-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#15 (2026-04-23;DOY=113)
if [ $resuming_from -le 2026105 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-04-23 -e 2026-04-23 
  modis_collect --interleave --cleanup --last-collected 2026105 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2026113 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-04d3 (#12)
  modis_window -b 2026-04-25 -e 2026-04-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-04d2 (#11)
  modis_window -b 2026-04-15 -e 2026-04-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#16 (2026-05-01;DOY=121)
if [ $resuming_from -le 2026113 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-05-01 -e 2026-05-01 
  modis_collect --interleave --cleanup --last-collected 2026113 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026121 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-05d1 (#13)
  modis_window -b 2026-05-05 -e 2026-05-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-04d3 (#12)
  modis_window -b 2026-04-25 -e 2026-04-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-04d2 (#11)
  modis_window -b 2026-04-15 -e 2026-04-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#17 (2026-05-09;DOY=129)
if [ $resuming_from -le 2026121 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-05-09 -e 2026-05-09 
  modis_collect --interleave --cleanup --last-collected 2026121 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026129 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-05d2 (#14)
  modis_window -b 2026-05-15 -e 2026-05-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-05d1 (#13)
  modis_window -b 2026-05-05 -e 2026-05-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-04d3 (#12)
  modis_window -b 2026-04-25 -e 2026-04-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#18 (2026-05-17;DOY=137)
if [ $resuming_from -le 2026129 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-05-17 -e 2026-05-17 
  modis_collect --interleave --cleanup --last-collected 2026129 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026137 -d ./VIM/SMOOTH ./VIM
  # CS1: 2026-05d2 (#14)
  modis_window -b 2026-05-15 -e 2026-05-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-05d1 (#13)
  modis_window -b 2026-05-05 -e 2026-05-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#19 (2026-05-25;DOY=145)
if [ $resuming_from -le 2026137 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-05-25 -e 2026-05-25 
  modis_collect --interleave --cleanup --last-collected 2026137 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026145 -d ./VIM/SMOOTH ./VIM
  # CS0: 2026-05d3 (#15)
  modis_window -b 2026-05-25 -e 2026-05-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-05d2 (#14)
  modis_window -b 2026-05-15 -e 2026-05-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#20 (2026-06-02;DOY=153)
if [ $resuming_from -le 2026145 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-06-02 -e 2026-06-02 
  modis_collect --interleave --cleanup --last-collected 2026145 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2026153 -d ./VIM/SMOOTH ./VIM
  # CS1: 2026-05d3 (#15)
  modis_window -b 2026-05-25 -e 2026-05-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2026-OTD#21 (2026-06-10;DOY=161)
if [ $resuming_from -le 2026153 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2026-06-10 -e 2026-06-10 
  modis_collect --interleave --cleanup --last-collected 2026153 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2026161 -d ./VIM/SMOOTH ./VIM
  # CS2: 2026-05d3 (#15)
  modis_window -b 2026-05-25 -e 2026-05-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.67,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi
