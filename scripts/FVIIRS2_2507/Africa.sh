#!/bin/bash
export PYTHONUNBUFFERED=1
# A1
export TILES="h15v07,h16v06,h16v07,h16v08,h17v05,h17v06,h17v07,h17v08,\
h18v05,h18v06,h18v07,h18v08,h18v09,h19v05,h19v06,h19v07,h19v08,h19v09,\
h19v10,h19v11,h19v12,h20v05,h20v06,h20v07,h20v08,h20v09,h20v10,h20v11,\
h20v12,h21v05,h21v06,h21v07,h21v08,h21v09,h21v10,h21v11,h22v07,h22v08,\
h22v09,h22v10,h22v11,h23v07,h23v08,h23v09,h23v10,h23v11"
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
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2012-02-02 -e 2013-01-25 VNP13A2
  modis_collect --cleanup .
  resuming_from="2013025"
else
  echo "--------------------------------------------"
  echo "Resuming processing from: $resuming_from"
  echo "--------------------------------------------"
fi
if [ $resuming_from -le 2013025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2013-02-02 -e 2014-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2013025 .
fi
if [ $resuming_from -le 2014025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2014-02-02 -e 2015-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2014025 .
fi
if [ $resuming_from -le 2015025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2015-02-02 -e 2016-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2015025 .
fi
if [ $resuming_from -le 2016025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2016-02-02 -e 2017-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2016025 .
fi
if [ $resuming_from -le 2017025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2017-02-02 -e 2018-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2017025 .
fi
if [ $resuming_from -le 2018025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2018-02-02 -e 2019-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2018025 .
fi
if [ $resuming_from -le 2019025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2019-02-02 -e 2020-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2019025 .
fi
if [ $resuming_from -le 2020025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2020-02-02 -e 2021-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2020025 .
fi
if [ $resuming_from -le 2021025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2021-02-02 -e 2022-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2021025 .
fi
if [ $resuming_from -le 2022025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2022-02-02 -e 2023-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2022025 .
fi
if [ $resuming_from -le 2023025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2023-02-02 -e 2024-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2023025 .
fi
if [ $resuming_from -le 2024025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2024-02-02 -e 2025-01-25 VNP13A2
  modis_collect --cleanup --last-collected 2024025 .
fi
if [ $resuming_from -le 2025025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --collection 002 \
    --tile-filter $TILES -b 2025-02-02 -e 2025-05-01 VNP13A2
  modis_collect --cleanup --last-collected 2025025 .
fi

# A2:
if [ $resuming_from -le 2025121 ]
then
  if [ -d "./VIM/SMOOTH" ]
  then
    rm -r ./VIM/SMOOTH
  fi
  modis_smooth --soptimize --tempint 10 \
    --last-collected 2025121 -d ./VIM/SMOOTH ./VIM
  modis_window -b 2012-02-05 -e 2025-05-05 --clip-valid --round-int 2 --region AFRICA \
    --roi -26.0,-35.0,60.0,38.0 --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --last-smoothed 2025121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2025129
if [ $resuming_from -le 2025121 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-05-09 -e 2025-05-09 VNP13A2
  modis_collect --cleanup --last-collected 2025121 .
  modis_smooth --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2025129 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-014
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-013
  modis_window -b 2025-05-05 -e 2025-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-012
  modis_window -b 2025-04-25 -e 2025-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2025137
if [ $resuming_from -le 2025129 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-05-17 -e 2025-05-17 VNP13A2
  modis_collect --cleanup --last-collected 2025129 .
  modis_smooth --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2025137 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-014
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-013
  modis_window -b 2025-05-05 -e 2025-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2025145
if [ $resuming_from -le 2025137 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-05-25 -e 2025-05-25 VNP13A2
  modis_collect --cleanup --last-collected 2025137 .
  modis_smooth --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2025145 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-015
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-014
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2025153
if [ $resuming_from -le 2025145 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-06-02 -e 2025-06-02 VNP13A2
  modis_collect --cleanup --last-collected 2025145 .
  modis_smooth --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2025153 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-015
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# Processing of 2025161
if [ $resuming_from -le 2025153 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --target-empty --match-begin --tile-filter $TILES \
    --collection 002 -b 2025-06-10 -e 2025-06-10 VNP13A2
  modis_collect --cleanup --last-collected 2025153 .
  modis_smooth --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2025161 -d ./VIM/SMOOTH ./VIM
  # CS2: 2025-015
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --overwrite --last-smoothed 2025161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

