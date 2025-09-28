#!/bin/bash
if [ ! -d "/var/modape" ] 
then
  cd /var
  git clone https://github.com/WFP-VAM/modape.git
  cd modape && git checkout tags/v1.2.0 -b modape-v1.2.0
  pip install .
fi
if [ ! -d "/var/storage/FVIIRS02_2507_LSO" ]
then
  mkdir /var/storage/FVIIRS02_2507_LSO
fi
cd /var/storage/FVIIRS02_2507_LSO
rm -f *.hdf
rm -f *.modapedl
export AFRICA_TILES="h15v07,h16v06,h16v07,h16v08,h17v05,h17v06,h17v07,h17v08,\
h18v05,h18v06,h18v07,h18v08,h18v09,h19v05,h19v06,h19v07,h19v08,h19v09,\
h19v10,h19v11,h19v12,h20v05,h20v06,h20v07,h20v08,h20v09,h20v10,h20v11,\
h20v12,h21v05,h21v06,h21v07,h21v08,h21v09,h21v10,h21v11,h22v07,h22v08,\
h22v09,h22v10,h22v11,h23v07,h23v08,h23v09,h23v10,h23v11"
export TILES="h20v12,h20v11"
export CMR_USERNAME=africanriskcapacity
export CMR_PASSWORD=Nasa4ARC!
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
  # B1-4: Download 64 timesteps back from 2025-05d1 (#13):
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $AFRICA_TILES -b 2023-12-19 -e 2023-12-19 VNP13A2
  modis_collect --interleave --cleanup --tiles-required $TILES .
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2023-12-27 -e 2025-05-01 VNP13A2
  modis_collect --interleave --cleanup .
  resuming_from="2025121"
else
  echo "--------------------------------------------"
  echo "Resuming processing from: $resuming_from"
  echo "--------------------------------------------"
fi

if [ $resuming_from -le 2025121 ]
then
  # B5: Import locally optimized smoothing grid:
  modis_smooth --tempint 10 \
    --sgrid /var/storage/FVIIRS02_2507_sgrid.tif \
    -d /var/storage/FVIIRS02_2507_LSO/VIM/SMOOTH \
    /var/storage/FVIIRS02_2507_LSO/VIM
fi

# C: Processing of 2025-OTD#17 (2025-05-09;DOY=129)
if [ $resuming_from -le 2025121 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-05-09 -e 2025-05-09 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025121 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025129 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-05d2 (#14)
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-05d1 (#13)
  modis_window -b 2025-05-05 -e 2025-05-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-04d3 (#12)
  modis_window -b 2025-04-25 -e 2025-04-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#18 (2025-05-17;DOY=137)
if [ $resuming_from -le 2025129 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-05-17 -e 2025-05-17 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025129 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025137 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-05d2 (#14)
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-05d1 (#13)
  modis_window -b 2025-05-05 -e 2025-05-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#19 (2025-05-25;DOY=145)
if [ $resuming_from -le 2025137 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-05-25 -e 2025-05-25 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025137 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025145 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-05d3 (#15)
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-05d2 (#14)
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#20 (2025-06-02;DOY=153)
if [ $resuming_from -le 2025145 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-06-02 -e 2025-06-02 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025145 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025153 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-06d1 (#16)
  modis_window -b 2025-06-05 -e 2025-06-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-05d3 (#15)
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#21 (2025-06-10;DOY=161)
if [ $resuming_from -le 2025153 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-06-10 -e 2025-06-10 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025153 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025161 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-06d2 (#17)
  modis_window -b 2025-06-15 -e 2025-06-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-06d1 (#16)
  modis_window -b 2025-06-05 -e 2025-06-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-05d3 (#15)
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#22 (2025-06-18;DOY=169)
if [ $resuming_from -le 2025161 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-06-18 -e 2025-06-18 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025161 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025169 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-06d3 (#18)
  modis_window -b 2025-06-25 -e 2025-06-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-06d2 (#17)
  modis_window -b 2025-06-15 -e 2025-06-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-06d1 (#16)
  modis_window -b 2025-06-05 -e 2025-06-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#23 (2025-06-26;DOY=177)
if [ $resuming_from -le 2025169 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-06-26 -e 2025-06-26 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025169 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025177 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-06d3 (#18)
  modis_window -b 2025-06-25 -e 2025-06-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-06d2 (#17)
  modis_window -b 2025-06-15 -e 2025-06-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#24 (2025-07-04;DOY=185)
if [ $resuming_from -le 2025177 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-07-04 -e 2025-07-04 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025177 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025185 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-07d1 (#19)
  modis_window -b 2025-07-05 -e 2025-07-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-06d3 (#18)
  modis_window -b 2025-06-25 -e 2025-06-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#25 (2025-07-12;DOY=193)
if [ $resuming_from -le 2025185 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-07-12 -e 2025-07-12 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025185 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025193 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-07d2 (#20)
  modis_window -b 2025-07-15 -e 2025-07-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-07d1 (#19)
  modis_window -b 2025-07-05 -e 2025-07-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#26 (2025-07-20;DOY=201)
if [ $resuming_from -le 2025193 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-07-20 -e 2025-07-20 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025193 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025201 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-07d3 (#21)
  modis_window -b 2025-07-25 -e 2025-07-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-07d2 (#20)
  modis_window -b 2025-07-15 -e 2025-07-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-07d1 (#19)
  modis_window -b 2025-07-05 -e 2025-07-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#27 (2025-07-28;DOY=209)
if [ $resuming_from -le 2025201 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-07-28 -e 2025-07-28 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025201 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025209 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-07d3 (#21)
  modis_window -b 2025-07-25 -e 2025-07-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-07d2 (#20)
  modis_window -b 2025-07-15 -e 2025-07-15 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#28 (2025-08-05;DOY=217)
if [ $resuming_from -le 2025209 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-08-05 -e 2025-08-05 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025209 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025217 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-08d1 (#22)
  modis_window -b 2025-08-05 -e 2025-08-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-07d3 (#21)
  modis_window -b 2025-07-25 -e 2025-07-25 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#29 (2025-08-13;DOY=225)
if [ $resuming_from -le 2025217 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-08-13 -e 2025-08-13 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025217 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025225 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-08d1 (#22)
  modis_window -b 2025-08-05 -e 2025-08-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2025-OTD#30 (2025-08-21;DOY=233)
if [ $resuming_from -le 2025225 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-08-21 -e 2025-08-21 VNP13A2
  modis_collect --interleave --cleanup --last-collected 2025225 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025233 -d ./VIM/SMOOTH ./VIM
  # CS2: 2025-08d1 (#22)
  modis_window -b 2025-08-05 -e 2025-08-05 --clip-valid --round-int 2 \
    --roi 27.02,-30.66,29.47,-28.57 --region LSO \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi
