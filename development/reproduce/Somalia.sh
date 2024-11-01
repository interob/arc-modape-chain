#!/bin/bash
if [ ! -d "/var/modape" ] 
then
  cd /var
  git clone https://github.com/WFP-VAM/modape.git
  cd modape && git checkout tags/v1.0.2 -b modape-v1.0.2
  python -m pip install .

  if [ ! -d "/var/storage/arc_modape_ndvi" ]
  then
    mkdir /var/storage/arc_modape_ndvi
  fi
  cd /var/storage/arc_modape_ndvi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_download.py" ]
  then
    ln -s /var/modape/modape/scripts/modis_download.py .
  fi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_collect.py" ]
  then
    ln -s /var/modape/modape/scripts/modis_collect.py .
  fi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_smooth.py" ]
  then
    ln -s /var/modape/modape/scripts/modis_smooth.py .
  fi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_window.py" ]
  then
    ln -s /var/modape/modape/scripts/modis_window.py .
  fi
fi
cd /var/storage/arc_modape_ndvi
rm -f *.hdf
# A1
# export TILES="h15v07,h16v06,h16v07,h16v08,h17v05,h17v06,h17v07,h17v08,\
# h18v05,h18v06,h18v07,h18v08,h18v09,h19v05,h19v06,h19v07,h19v08,h19v09,\
# h19v10,h19v11,h19v12,h20v05,h20v06,h20v07,h20v08,h20v09,h20v10,h20v11,\
# h20v12,h21v05,h21v06,h21v07,h21v08,h21v09,h21v10,h21v11,h22v07,h22v08,\
# h22v09,h22v10,h22v11,h23v07,h23v08,h23v09,h23v10,h23v11"
export TILES="h22v07,h22v08,h22v09,h23v07,h23v07,h23v08"
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
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2021-01-01 -e 2021-12-27 M?D13A2
  python modis_collect.py --interleave --cleanup .
  resuming_from="2021361"
else
  echo "--------------------------------------------"
  echo "Resuming processing from: $resuming_from"
  echo "--------------------------------------------"
fi
if [ $resuming_from -le 2021361 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2022-01-01 -e 2022-12-27 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2021361 .
fi
if [ $resuming_from -le 2022361 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2023-01-01 -e 2023-12-27 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2022361 .
fi
if [ $resuming_from -le 2023361 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2024-01-01 -e 2024-02-21 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2023361 .
fi

# A2:
if [ $resuming_from -le 2024049 ]
then
  if [ -d "./VIM/SMOOTH" ]
  then
    rm -r ./VIM/SMOOTH
  fi
  python modis_smooth.py --soptimize --tempint 10 \
    --last-collected 2024049 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2021-01-05 -e 2024-02-25 --clip-valid --round-int 2 --region SOM \
    --roi 40.0,-2.0,52.0,12.0 --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --last-smoothed 2024049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2024057 (CS1: 2024-006)
if [ $resuming_from -le 2024049 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-02-26 -e 2024-02-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2024049 .
  python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024057 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-02-15 -e 2024-02-15 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2024065 (CS0: 2024-007)
if [ $resuming_from -le 2024057 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-05 -e 2024-03-05 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2024057 .
  python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024065 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2024-03-05 -e 2024-03-05 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2024073 (CS0: 2024-008)
if [ $resuming_from -le 2024065 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-13 -e 2024-03-13 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2024065 .
  python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024073 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2024-03-15 -e 2024-03-15 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-03-05 -e 2024-03-05 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2024081 (CS0: 2024-009)
if [ $resuming_from -le 2024073 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-21 -e 2024-03-21 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2024073 .
  python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024081 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2024-03-25 -e 2024-03-25 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-03-15 -e 2024-03-15 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-03-05 -e 2024-03-05 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2024089 (CS0: 2024-010)
if [ $resuming_from -le 2024081 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-29 -e 2024-03-29 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2024081 .
  python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024089 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2024-04-05 -e 2024-04-05 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-03-25 -e 2024-03-25 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-03-15 -e 2024-03-15 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2024097 (CS1: 2024-010)
if [ $resuming_from -le 2024089 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-04-06 -e 2024-04-06 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2024089 .
  python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024097 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2024-04-05 -e 2024-04-05 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-03-25 -e 2024-03-25 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2024105 (CS0: 2024-011)
if [ $resuming_from -le 2024097 ]
then
  python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-04-14 -e 2024-04-14 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2024097 .
  python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024105 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2024-04-15 -e 2024-04-15 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  python modis_window.py -b 2024-04-05 -e 2024-04-05 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2024105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi
