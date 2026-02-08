#!/bin/bash
export PYTHONUNBUFFERED=1
if [ ! -d "/var/storage/modape" ] 
then
  cd /var/storage
  git clone https://github.com/WFP-VAM/modape.git
  cd modape && git checkout tags/v1.2.0 -b modape-v1.2.0
  python -m pip install .

  if [ ! -d "/var/storage/arc_modape_ndvi" ]
  then
    mkdir /var/storage/arc_modape_ndvi
  fi
  cd /var/storage/arc_modape_ndvi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_download.py" ]
  then
    ln -s /var/storage/modape/modape/scripts/modis_download.py .
  fi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_collect.py" ]
  then
    ln -s /var/storage/modape/modape/scripts/modis_collect.py .
  fi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_smooth.py" ]
  then
    ln -s /var/storage/modape/modape/scripts/modis_smooth.py .
  fi
  if [ ! -f "/var/storage/arc_modape_ndvi/modis_window.py" ]
  then
    ln -s /var/storage/modape/modape/scripts/modis_window.py .
  fi
fi
cd /var/storage/arc_modape_ndvi
rm -f *.hdf
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
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2002-07-04 -e 2003-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup .
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
else
  echo "--------------------------------------------"
  echo "Resuming processing from: $resuming_from"
  echo "--------------------------------------------"
fi
if [ $resuming_from -eq 2003177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2003-07-04 -e 2004-06-25 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2003177 .
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
fi
if [ $resuming_from -eq 2004177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2004-07-03 -e 2005-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2004177 .
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
fi
if [ $resuming_from -eq 2005177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2005-07-04 -e 2006-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2005177 .
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
fi
if [ $resuming_from -eq 2006177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2006-07-04 -e 2007-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2006177 .
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
fi
if [ $resuming_from -eq 2007177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2007-07-04 -e 2008-06-25 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2007177 .
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
fi
if [ $resuming_from -eq 2008177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2008-07-03 -e 2009-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2008177 .
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
fi
if [ $resuming_from -eq 2009177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2009-07-04 -e 2010-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2009177 .
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
fi
if [ $resuming_from -eq 2010177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2010-07-04 -e 2011-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2010177 .
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
fi
if [ $resuming_from -eq 2011177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2011-07-04 -e 2012-06-25 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2011177 .
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
fi
if [ $resuming_from -eq 2012177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2012-07-03 -e 2013-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2012177 .
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
fi
if [ $resuming_from -eq 2013177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2013-07-04 -e 2014-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2013177 .
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
fi
if [ $resuming_from -eq 2014177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2014-07-04 -e 2015-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2014177 .
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
fi
if [ $resuming_from -eq 2015177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2015-07-04 -e 2016-06-25 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2015177 .
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
fi
if [ $resuming_from -eq 2016177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2016-07-03 -e 2017-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2016177 .
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
fi
if [ $resuming_from -eq 2017177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2017-07-04 -e 2018-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2017177 .
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
fi
if [ $resuming_from -eq 2018177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2018-07-04 -e 2019-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2018177 .
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
fi
if [ $resuming_from -eq 2019177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2019-07-04 -e 2020-06-25 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2019177 .
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
fi
if [ $resuming_from -eq 2020177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2020-07-03 -e 2021-06-26 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2020177 .
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
fi
if [ $resuming_from -eq 2021177 ]
then
  python modis_download.py --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --collection 061 \
    --tile-filter $TILES -b 2021-07-04 -e 2021-12-31 M?D13A2
  python modis_collect.py --interleave --cleanup --last-collected 2021177 .
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
fi

# A2:
if [ $resuming_from -eq 2021361 ]
then
  if [ -d "./VIM/SMOOTH" ]
  then
    rm -r ./VIM/SMOOTH
  fi
  python modis_smooth.py --soptimize --tempint 10 \
    --last-collected 2021361 -d ./VIM/SMOOTH ./VIM
  python modis_window.py -b 2002-07-15 -e 2021-12-25 --clip-valid --round-int 2 --region AFRICA \
    --roi -26.0,-35.0,60.0,38.0 --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --last-smoothed 2021361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi

# C: Processing of 2022-OTD#01 (2022-01-01;DOY=1)
if [ $resuming_from -eq 2021361 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-01-01 -e 2022-01-01 
  modis_collect --interleave --cleanup --last-collected 2021361 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022001 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-01d1 (#01)
  modis_window -b 2022-01-05 -e 2022-01-05 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2021-12d3 (#36)
  modis_window -b 2021-12-25 -e 2021-12-25 --clip-valid --round-int 2 \
    --roi 40.0,-2.0,52.0,12.0 --region SOM \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#02 (2022-01-09;DOY=9)
if [ $resuming_from -eq 2022001 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-01-09 -e 2022-01-09 
  modis_collect --interleave --cleanup --last-collected 2022001 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022009 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-01d2 (#02)
  modis_window -b 2022-01-15 -e 2022-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-01d1 (#01)
  modis_window -b 2022-01-05 -e 2022-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#03 (2022-01-17;DOY=17)
if [ $resuming_from -eq 2022009 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-01-17 -e 2022-01-17 
  modis_collect --interleave --cleanup --last-collected 2022009 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022017 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-01d2 (#02)
  modis_window -b 2022-01-15 -e 2022-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-01d1 (#01)
  modis_window -b 2022-01-05 -e 2022-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#04 (2022-01-25;DOY=25)
if [ $resuming_from -eq 2022017 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-01-25 -e 2022-01-25 
  modis_collect --interleave --cleanup --last-collected 2022017 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022025 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-01d3 (#03)
  modis_window -b 2022-01-25 -e 2022-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-01d2 (#02)
  modis_window -b 2022-01-15 -e 2022-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#05 (2022-02-02;DOY=33)
if [ $resuming_from -eq 2022025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-02-02 -e 2022-02-02 
  modis_collect --interleave --cleanup --last-collected 2022025 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022033 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-02d1 (#04)
  modis_window -b 2022-02-05 -e 2022-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-01d3 (#03)
  modis_window -b 2022-01-25 -e 2022-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#06 (2022-02-10;DOY=41)
if [ $resuming_from -eq 2022033 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-02-10 -e 2022-02-10 
  modis_collect --interleave --cleanup --last-collected 2022033 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022041 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-02d2 (#05)
  modis_window -b 2022-02-15 -e 2022-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-02d1 (#04)
  modis_window -b 2022-02-05 -e 2022-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-01d3 (#03)
  modis_window -b 2022-01-25 -e 2022-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#07 (2022-02-18;DOY=49)
if [ $resuming_from -eq 2022041 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-02-18 -e 2022-02-18 
  modis_collect --interleave --cleanup --last-collected 2022041 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022049 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-02d3 (#06)
  modis_window -b 2022-02-25 -e 2022-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-02d2 (#05)
  modis_window -b 2022-02-15 -e 2022-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-02d1 (#04)
  modis_window -b 2022-02-05 -e 2022-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#08 (2022-02-26;DOY=57)
if [ $resuming_from -eq 2022049 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-02-26 -e 2022-02-26 
  modis_collect --interleave --cleanup --last-collected 2022049 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022057 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-03d1 (#07)
  modis_window -b 2022-03-05 -e 2022-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-02d3 (#06)
  modis_window -b 2022-02-25 -e 2022-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-02d2 (#05)
  modis_window -b 2022-02-15 -e 2022-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#09 (2022-03-06;DOY=65)
if [ $resuming_from -eq 2022057 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-03-06 -e 2022-03-06 
  modis_collect --interleave --cleanup --last-collected 2022057 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022065 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-03d1 (#07)
  modis_window -b 2022-03-05 -e 2022-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-02d3 (#06)
  modis_window -b 2022-02-25 -e 2022-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#10 (2022-03-14;DOY=73)
if [ $resuming_from -eq 2022065 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-03-14 -e 2022-03-14 
  modis_collect --interleave --cleanup --last-collected 2022065 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022073 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-03d2 (#08)
  modis_window -b 2022-03-15 -e 2022-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-03d1 (#07)
  modis_window -b 2022-03-05 -e 2022-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#11 (2022-03-22;DOY=81)
if [ $resuming_from -eq 2022073 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-03-22 -e 2022-03-22 
  modis_collect --interleave --cleanup --last-collected 2022073 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022081 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-03d3 (#09)
  modis_window -b 2022-03-25 -e 2022-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-03d2 (#08)
  modis_window -b 2022-03-15 -e 2022-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#12 (2022-03-30;DOY=89)
if [ $resuming_from -eq 2022081 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-03-30 -e 2022-03-30 
  modis_collect --interleave --cleanup --last-collected 2022081 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022089 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-04d1 (#10)
  modis_window -b 2022-04-05 -e 2022-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-03d3 (#09)
  modis_window -b 2022-03-25 -e 2022-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-03d2 (#08)
  modis_window -b 2022-03-15 -e 2022-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#13 (2022-04-07;DOY=97)
if [ $resuming_from -eq 2022089 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-04-07 -e 2022-04-07 
  modis_collect --interleave --cleanup --last-collected 2022089 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022097 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-04d1 (#10)
  modis_window -b 2022-04-05 -e 2022-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-03d3 (#09)
  modis_window -b 2022-03-25 -e 2022-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#14 (2022-04-15;DOY=105)
if [ $resuming_from -eq 2022097 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-04-15 -e 2022-04-15 
  modis_collect --interleave --cleanup --last-collected 2022097 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022105 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-04d2 (#11)
  modis_window -b 2022-04-15 -e 2022-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-04d1 (#10)
  modis_window -b 2022-04-05 -e 2022-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#15 (2022-04-23;DOY=113)
if [ $resuming_from -eq 2022105 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-04-23 -e 2022-04-23 
  modis_collect --interleave --cleanup --last-collected 2022105 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022113 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-04d3 (#12)
  modis_window -b 2022-04-25 -e 2022-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-04d2 (#11)
  modis_window -b 2022-04-15 -e 2022-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#16 (2022-05-01;DOY=121)
if [ $resuming_from -eq 2022113 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-05-01 -e 2022-05-01 
  modis_collect --interleave --cleanup --last-collected 2022113 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022121 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-05d1 (#13)
  modis_window -b 2022-05-05 -e 2022-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-04d3 (#12)
  modis_window -b 2022-04-25 -e 2022-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-04d2 (#11)
  modis_window -b 2022-04-15 -e 2022-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#17 (2022-05-09;DOY=129)
if [ $resuming_from -eq 2022121 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-05-09 -e 2022-05-09 
  modis_collect --interleave --cleanup --last-collected 2022121 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022129 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-05d2 (#14)
  modis_window -b 2022-05-15 -e 2022-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-05d1 (#13)
  modis_window -b 2022-05-05 -e 2022-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-04d3 (#12)
  modis_window -b 2022-04-25 -e 2022-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#18 (2022-05-17;DOY=137)
if [ $resuming_from -eq 2022129 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-05-17 -e 2022-05-17 
  modis_collect --interleave --cleanup --last-collected 2022129 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022137 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-05d2 (#14)
  modis_window -b 2022-05-15 -e 2022-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-05d1 (#13)
  modis_window -b 2022-05-05 -e 2022-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#19 (2022-05-25;DOY=145)
if [ $resuming_from -eq 2022137 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-05-25 -e 2022-05-25 
  modis_collect --interleave --cleanup --last-collected 2022137 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022145 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-05d3 (#15)
  modis_window -b 2022-05-25 -e 2022-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-05d2 (#14)
  modis_window -b 2022-05-15 -e 2022-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#20 (2022-06-02;DOY=153)
if [ $resuming_from -eq 2022145 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-06-02 -e 2022-06-02 
  modis_collect --interleave --cleanup --last-collected 2022145 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022153 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-06d1 (#16)
  modis_window -b 2022-06-05 -e 2022-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-05d3 (#15)
  modis_window -b 2022-05-25 -e 2022-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#21 (2022-06-10;DOY=161)
if [ $resuming_from -eq 2022153 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-06-10 -e 2022-06-10 
  modis_collect --interleave --cleanup --last-collected 2022153 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022161 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-06d2 (#17)
  modis_window -b 2022-06-15 -e 2022-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-06d1 (#16)
  modis_window -b 2022-06-05 -e 2022-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-05d3 (#15)
  modis_window -b 2022-05-25 -e 2022-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#22 (2022-06-18;DOY=169)
if [ $resuming_from -eq 2022161 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-06-18 -e 2022-06-18 
  modis_collect --interleave --cleanup --last-collected 2022161 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022169 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-06d3 (#18)
  modis_window -b 2022-06-25 -e 2022-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-06d2 (#17)
  modis_window -b 2022-06-15 -e 2022-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-06d1 (#16)
  modis_window -b 2022-06-05 -e 2022-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#23 (2022-06-26;DOY=177)
if [ $resuming_from -eq 2022169 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-06-26 -e 2022-06-26 
  modis_collect --interleave --cleanup --last-collected 2022169 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022177 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-06d3 (#18)
  modis_window -b 2022-06-25 -e 2022-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-06d2 (#17)
  modis_window -b 2022-06-15 -e 2022-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#24 (2022-07-04;DOY=185)
if [ $resuming_from -eq 2022177 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-07-04 -e 2022-07-04 
  modis_collect --interleave --cleanup --last-collected 2022177 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022185 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-07d1 (#19)
  modis_window -b 2022-07-05 -e 2022-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-06d3 (#18)
  modis_window -b 2022-06-25 -e 2022-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#25 (2022-07-12;DOY=193)
if [ $resuming_from -eq 2022185 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-07-12 -e 2022-07-12 
  modis_collect --interleave --cleanup --last-collected 2022185 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022193 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-07d2 (#20)
  modis_window -b 2022-07-15 -e 2022-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-07d1 (#19)
  modis_window -b 2022-07-05 -e 2022-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#26 (2022-07-20;DOY=201)
if [ $resuming_from -eq 2022193 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-07-20 -e 2022-07-20 
  modis_collect --interleave --cleanup --last-collected 2022193 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022201 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-07d3 (#21)
  modis_window -b 2022-07-25 -e 2022-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-07d2 (#20)
  modis_window -b 2022-07-15 -e 2022-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-07d1 (#19)
  modis_window -b 2022-07-05 -e 2022-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#27 (2022-07-28;DOY=209)
if [ $resuming_from -eq 2022201 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-07-28 -e 2022-07-28 
  modis_collect --interleave --cleanup --last-collected 2022201 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022209 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-07d3 (#21)
  modis_window -b 2022-07-25 -e 2022-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-07d2 (#20)
  modis_window -b 2022-07-15 -e 2022-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#28 (2022-08-05;DOY=217)
if [ $resuming_from -eq 2022209 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-08-05 -e 2022-08-05 
  modis_collect --interleave --cleanup --last-collected 2022209 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022217 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-08d1 (#22)
  modis_window -b 2022-08-05 -e 2022-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-07d3 (#21)
  modis_window -b 2022-07-25 -e 2022-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#29 (2022-08-13;DOY=225)
if [ $resuming_from -eq 2022217 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-08-13 -e 2022-08-13 
  modis_collect --interleave --cleanup --last-collected 2022217 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022225 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-08d2 (#23)
  modis_window -b 2022-08-15 -e 2022-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-08d1 (#22)
  modis_window -b 2022-08-05 -e 2022-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#30 (2022-08-21;DOY=233)
if [ $resuming_from -eq 2022225 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-08-21 -e 2022-08-21 
  modis_collect --interleave --cleanup --last-collected 2022225 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022233 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-08d3 (#24)
  modis_window -b 2022-08-25 -e 2022-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-08d2 (#23)
  modis_window -b 2022-08-15 -e 2022-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-08d1 (#22)
  modis_window -b 2022-08-05 -e 2022-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#31 (2022-08-29;DOY=241)
if [ $resuming_from -eq 2022233 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-08-29 -e 2022-08-29 
  modis_collect --interleave --cleanup --last-collected 2022233 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022241 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-09d1 (#25)
  modis_window -b 2022-09-05 -e 2022-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-08d3 (#24)
  modis_window -b 2022-08-25 -e 2022-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-08d2 (#23)
  modis_window -b 2022-08-15 -e 2022-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#32 (2022-09-06;DOY=249)
if [ $resuming_from -eq 2022241 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-09-06 -e 2022-09-06 
  modis_collect --interleave --cleanup --last-collected 2022241 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022249 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-09d1 (#25)
  modis_window -b 2022-09-05 -e 2022-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-08d3 (#24)
  modis_window -b 2022-08-25 -e 2022-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#33 (2022-09-14;DOY=257)
if [ $resuming_from -eq 2022249 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-09-14 -e 2022-09-14 
  modis_collect --interleave --cleanup --last-collected 2022249 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022257 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-09d2 (#26)
  modis_window -b 2022-09-15 -e 2022-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-09d1 (#25)
  modis_window -b 2022-09-05 -e 2022-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#34 (2022-09-22;DOY=265)
if [ $resuming_from -eq 2022257 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-09-22 -e 2022-09-22 
  modis_collect --interleave --cleanup --last-collected 2022257 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022265 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-09d3 (#27)
  modis_window -b 2022-09-25 -e 2022-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-09d2 (#26)
  modis_window -b 2022-09-15 -e 2022-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#35 (2022-09-30;DOY=273)
if [ $resuming_from -eq 2022265 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-09-30 -e 2022-09-30 
  modis_collect --interleave --cleanup --last-collected 2022265 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022273 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-10d1 (#28)
  modis_window -b 2022-10-05 -e 2022-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-09d3 (#27)
  modis_window -b 2022-09-25 -e 2022-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-09d2 (#26)
  modis_window -b 2022-09-15 -e 2022-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#36 (2022-10-08;DOY=281)
if [ $resuming_from -eq 2022273 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-10-08 -e 2022-10-08 
  modis_collect --interleave --cleanup --last-collected 2022273 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022281 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-10d2 (#29)
  modis_window -b 2022-10-15 -e 2022-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-10d1 (#28)
  modis_window -b 2022-10-05 -e 2022-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-09d3 (#27)
  modis_window -b 2022-09-25 -e 2022-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#37 (2022-10-16;DOY=289)
if [ $resuming_from -eq 2022281 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-10-16 -e 2022-10-16 
  modis_collect --interleave --cleanup --last-collected 2022281 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022289 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-10d2 (#29)
  modis_window -b 2022-10-15 -e 2022-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-10d1 (#28)
  modis_window -b 2022-10-05 -e 2022-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#38 (2022-10-24;DOY=297)
if [ $resuming_from -eq 2022289 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-10-24 -e 2022-10-24 
  modis_collect --interleave --cleanup --last-collected 2022289 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022297 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-10d3 (#30)
  modis_window -b 2022-10-25 -e 2022-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-10d2 (#29)
  modis_window -b 2022-10-15 -e 2022-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#39 (2022-11-01;DOY=305)
if [ $resuming_from -eq 2022297 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-11-01 -e 2022-11-01 
  modis_collect --interleave --cleanup --last-collected 2022297 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022305 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-11d1 (#31)
  modis_window -b 2022-11-05 -e 2022-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-10d3 (#30)
  modis_window -b 2022-10-25 -e 2022-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#40 (2022-11-09;DOY=313)
if [ $resuming_from -eq 2022305 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-11-09 -e 2022-11-09 
  modis_collect --interleave --cleanup --last-collected 2022305 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022313 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-11d2 (#32)
  modis_window -b 2022-11-15 -e 2022-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-11d1 (#31)
  modis_window -b 2022-11-05 -e 2022-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-10d3 (#30)
  modis_window -b 2022-10-25 -e 2022-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#41 (2022-11-17;DOY=321)
if [ $resuming_from -eq 2022313 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-11-17 -e 2022-11-17 
  modis_collect --interleave --cleanup --last-collected 2022313 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022321 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-11d2 (#32)
  modis_window -b 2022-11-15 -e 2022-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-11d1 (#31)
  modis_window -b 2022-11-05 -e 2022-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#42 (2022-11-25;DOY=329)
if [ $resuming_from -eq 2022321 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-11-25 -e 2022-11-25 
  modis_collect --interleave --cleanup --last-collected 2022321 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022329 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-11d3 (#33)
  modis_window -b 2022-11-25 -e 2022-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-11d2 (#32)
  modis_window -b 2022-11-15 -e 2022-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#43 (2022-12-03;DOY=337)
if [ $resuming_from -eq 2022329 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-12-03 -e 2022-12-03 
  modis_collect --interleave --cleanup --last-collected 2022329 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2022337 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-12d1 (#34)
  modis_window -b 2022-12-05 -e 2022-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-11d3 (#33)
  modis_window -b 2022-11-25 -e 2022-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#44 (2022-12-11;DOY=345)
if [ $resuming_from -eq 2022337 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-12-11 -e 2022-12-11 
  modis_collect --interleave --cleanup --last-collected 2022337 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022345 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-12d2 (#35)
  modis_window -b 2022-12-15 -e 2022-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-12d1 (#34)
  modis_window -b 2022-12-05 -e 2022-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-11d3 (#33)
  modis_window -b 2022-11-25 -e 2022-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#45 (2022-12-19;DOY=353)
if [ $resuming_from -eq 2022345 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-12-19 -e 2022-12-19 
  modis_collect --interleave --cleanup --last-collected 2022345 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022353 -d ./VIM/SMOOTH ./VIM
  # CS0: 2022-12d3 (#36)
  modis_window -b 2022-12-25 -e 2022-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2022353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2022-12d2 (#35)
  modis_window -b 2022-12-15 -e 2022-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-12d1 (#34)
  modis_window -b 2022-12-05 -e 2022-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2022-OTD#46 (2022-12-27;DOY=361)
if [ $resuming_from -eq 2022353 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2022-12-27 -e 2022-12-27 
  modis_collect --interleave --cleanup --last-collected 2022353 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2022361 -d ./VIM/SMOOTH ./VIM
  # CS1: 2022-12d3 (#36)
  modis_window -b 2022-12-25 -e 2022-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2022361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-12d2 (#35)
  modis_window -b 2022-12-15 -e 2022-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2022361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#01 (2023-01-01;DOY=1)
if [ $resuming_from -eq 2022361 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-01-01 -e 2023-01-01 
  modis_collect --interleave --cleanup --last-collected 2022361 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023001 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-01d1 (#01)
  modis_window -b 2023-01-05 -e 2023-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2022-12d3 (#36)
  modis_window -b 2022-12-25 -e 2022-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#02 (2023-01-09;DOY=9)
if [ $resuming_from -eq 2023001 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-01-09 -e 2023-01-09 
  modis_collect --interleave --cleanup --last-collected 2023001 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023009 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-01d2 (#02)
  modis_window -b 2023-01-15 -e 2023-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-01d1 (#01)
  modis_window -b 2023-01-05 -e 2023-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#03 (2023-01-17;DOY=17)
if [ $resuming_from -eq 2023009 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-01-17 -e 2023-01-17 
  modis_collect --interleave --cleanup --last-collected 2023009 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023017 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-01d2 (#02)
  modis_window -b 2023-01-15 -e 2023-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-01d1 (#01)
  modis_window -b 2023-01-05 -e 2023-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#04 (2023-01-25;DOY=25)
if [ $resuming_from -eq 2023017 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-01-25 -e 2023-01-25 
  modis_collect --interleave --cleanup --last-collected 2023017 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023025 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-01d3 (#03)
  modis_window -b 2023-01-25 -e 2023-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-01d2 (#02)
  modis_window -b 2023-01-15 -e 2023-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#05 (2023-02-02;DOY=33)
if [ $resuming_from -eq 2023025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-02-02 -e 2023-02-02 
  modis_collect --interleave --cleanup --last-collected 2023025 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023033 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-02d1 (#04)
  modis_window -b 2023-02-05 -e 2023-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-01d3 (#03)
  modis_window -b 2023-01-25 -e 2023-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#06 (2023-02-10;DOY=41)
if [ $resuming_from -eq 2023033 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-02-10 -e 2023-02-10 
  modis_collect --interleave --cleanup --last-collected 2023033 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023041 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-02d2 (#05)
  modis_window -b 2023-02-15 -e 2023-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-02d1 (#04)
  modis_window -b 2023-02-05 -e 2023-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-01d3 (#03)
  modis_window -b 2023-01-25 -e 2023-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#07 (2023-02-18;DOY=49)
if [ $resuming_from -eq 2023041 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-02-18 -e 2023-02-18 
  modis_collect --interleave --cleanup --last-collected 2023041 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023049 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-02d3 (#06)
  modis_window -b 2023-02-25 -e 2023-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-02d2 (#05)
  modis_window -b 2023-02-15 -e 2023-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-02d1 (#04)
  modis_window -b 2023-02-05 -e 2023-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#08 (2023-02-26;DOY=57)
if [ $resuming_from -eq 2023049 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-02-26 -e 2023-02-26 
  modis_collect --interleave --cleanup --last-collected 2023049 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023057 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-03d1 (#07)
  modis_window -b 2023-03-05 -e 2023-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-02d3 (#06)
  modis_window -b 2023-02-25 -e 2023-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-02d2 (#05)
  modis_window -b 2023-02-15 -e 2023-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#09 (2023-03-06;DOY=65)
if [ $resuming_from -eq 2023057 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-03-06 -e 2023-03-06 
  modis_collect --interleave --cleanup --last-collected 2023057 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023065 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-03d1 (#07)
  modis_window -b 2023-03-05 -e 2023-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-02d3 (#06)
  modis_window -b 2023-02-25 -e 2023-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#10 (2023-03-14;DOY=73)
if [ $resuming_from -eq 2023065 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-03-14 -e 2023-03-14 
  modis_collect --interleave --cleanup --last-collected 2023065 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023073 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-03d2 (#08)
  modis_window -b 2023-03-15 -e 2023-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-03d1 (#07)
  modis_window -b 2023-03-05 -e 2023-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#11 (2023-03-22;DOY=81)
if [ $resuming_from -eq 2023073 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-03-22 -e 2023-03-22 
  modis_collect --interleave --cleanup --last-collected 2023073 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023081 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-03d3 (#09)
  modis_window -b 2023-03-25 -e 2023-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-03d2 (#08)
  modis_window -b 2023-03-15 -e 2023-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#12 (2023-03-30;DOY=89)
if [ $resuming_from -eq 2023081 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-03-30 -e 2023-03-30 
  modis_collect --interleave --cleanup --last-collected 2023081 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023089 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-04d1 (#10)
  modis_window -b 2023-04-05 -e 2023-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-03d3 (#09)
  modis_window -b 2023-03-25 -e 2023-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-03d2 (#08)
  modis_window -b 2023-03-15 -e 2023-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#13 (2023-04-07;DOY=97)
if [ $resuming_from -eq 2023089 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-04-07 -e 2023-04-07 
  modis_collect --interleave --cleanup --last-collected 2023089 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023097 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-04d1 (#10)
  modis_window -b 2023-04-05 -e 2023-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-03d3 (#09)
  modis_window -b 2023-03-25 -e 2023-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#14 (2023-04-15;DOY=105)
if [ $resuming_from -eq 2023097 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-04-15 -e 2023-04-15 
  modis_collect --interleave --cleanup --last-collected 2023097 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023105 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-04d2 (#11)
  modis_window -b 2023-04-15 -e 2023-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-04d1 (#10)
  modis_window -b 2023-04-05 -e 2023-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#15 (2023-04-23;DOY=113)
if [ $resuming_from -eq 2023105 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-04-23 -e 2023-04-23 
  modis_collect --interleave --cleanup --last-collected 2023105 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023113 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-04d3 (#12)
  modis_window -b 2023-04-25 -e 2023-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-04d2 (#11)
  modis_window -b 2023-04-15 -e 2023-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#16 (2023-05-01;DOY=121)
if [ $resuming_from -eq 2023113 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-05-01 -e 2023-05-01 
  modis_collect --interleave --cleanup --last-collected 2023113 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023121 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-05d1 (#13)
  modis_window -b 2023-05-05 -e 2023-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-04d3 (#12)
  modis_window -b 2023-04-25 -e 2023-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-04d2 (#11)
  modis_window -b 2023-04-15 -e 2023-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#17 (2023-05-09;DOY=129)
if [ $resuming_from -eq 2023121 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-05-09 -e 2023-05-09 
  modis_collect --interleave --cleanup --last-collected 2023121 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023129 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-05d2 (#14)
  modis_window -b 2023-05-15 -e 2023-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-05d1 (#13)
  modis_window -b 2023-05-05 -e 2023-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-04d3 (#12)
  modis_window -b 2023-04-25 -e 2023-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#18 (2023-05-17;DOY=137)
if [ $resuming_from -eq 2023129 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-05-17 -e 2023-05-17 
  modis_collect --interleave --cleanup --last-collected 2023129 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023137 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-05d2 (#14)
  modis_window -b 2023-05-15 -e 2023-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-05d1 (#13)
  modis_window -b 2023-05-05 -e 2023-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#19 (2023-05-25;DOY=145)
if [ $resuming_from -eq 2023137 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-05-25 -e 2023-05-25 
  modis_collect --interleave --cleanup --last-collected 2023137 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023145 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-05d3 (#15)
  modis_window -b 2023-05-25 -e 2023-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-05d2 (#14)
  modis_window -b 2023-05-15 -e 2023-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#20 (2023-06-02;DOY=153)
if [ $resuming_from -eq 2023145 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-06-02 -e 2023-06-02 
  modis_collect --interleave --cleanup --last-collected 2023145 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023153 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-06d1 (#16)
  modis_window -b 2023-06-05 -e 2023-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-05d3 (#15)
  modis_window -b 2023-05-25 -e 2023-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#21 (2023-06-10;DOY=161)
if [ $resuming_from -eq 2023153 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-06-10 -e 2023-06-10 
  modis_collect --interleave --cleanup --last-collected 2023153 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023161 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-06d2 (#17)
  modis_window -b 2023-06-15 -e 2023-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-06d1 (#16)
  modis_window -b 2023-06-05 -e 2023-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-05d3 (#15)
  modis_window -b 2023-05-25 -e 2023-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#22 (2023-06-18;DOY=169)
if [ $resuming_from -eq 2023161 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-06-18 -e 2023-06-18 
  modis_collect --interleave --cleanup --last-collected 2023161 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023169 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-06d3 (#18)
  modis_window -b 2023-06-25 -e 2023-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-06d2 (#17)
  modis_window -b 2023-06-15 -e 2023-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-06d1 (#16)
  modis_window -b 2023-06-05 -e 2023-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#23 (2023-06-26;DOY=177)
if [ $resuming_from -eq 2023169 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-06-26 -e 2023-06-26 
  modis_collect --interleave --cleanup --last-collected 2023169 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023177 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-06d3 (#18)
  modis_window -b 2023-06-25 -e 2023-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-06d2 (#17)
  modis_window -b 2023-06-15 -e 2023-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#24 (2023-07-04;DOY=185)
if [ $resuming_from -eq 2023177 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-07-04 -e 2023-07-04 
  modis_collect --interleave --cleanup --last-collected 2023177 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023185 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-07d1 (#19)
  modis_window -b 2023-07-05 -e 2023-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-06d3 (#18)
  modis_window -b 2023-06-25 -e 2023-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#25 (2023-07-12;DOY=193)
if [ $resuming_from -eq 2023185 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-07-12 -e 2023-07-12 
  modis_collect --interleave --cleanup --last-collected 2023185 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023193 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-07d2 (#20)
  modis_window -b 2023-07-15 -e 2023-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-07d1 (#19)
  modis_window -b 2023-07-05 -e 2023-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#26 (2023-07-20;DOY=201)
if [ $resuming_from -eq 2023193 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-07-20 -e 2023-07-20 
  modis_collect --interleave --cleanup --last-collected 2023193 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023201 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-07d3 (#21)
  modis_window -b 2023-07-25 -e 2023-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-07d2 (#20)
  modis_window -b 2023-07-15 -e 2023-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-07d1 (#19)
  modis_window -b 2023-07-05 -e 2023-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#27 (2023-07-28;DOY=209)
if [ $resuming_from -eq 2023201 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-07-28 -e 2023-07-28 
  modis_collect --interleave --cleanup --last-collected 2023201 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023209 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-07d3 (#21)
  modis_window -b 2023-07-25 -e 2023-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-07d2 (#20)
  modis_window -b 2023-07-15 -e 2023-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#28 (2023-08-05;DOY=217)
if [ $resuming_from -eq 2023209 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-08-05 -e 2023-08-05 
  modis_collect --interleave --cleanup --last-collected 2023209 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023217 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-08d1 (#22)
  modis_window -b 2023-08-05 -e 2023-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-07d3 (#21)
  modis_window -b 2023-07-25 -e 2023-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#29 (2023-08-13;DOY=225)
if [ $resuming_from -eq 2023217 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-08-13 -e 2023-08-13 
  modis_collect --interleave --cleanup --last-collected 2023217 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023225 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-08d2 (#23)
  modis_window -b 2023-08-15 -e 2023-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-08d1 (#22)
  modis_window -b 2023-08-05 -e 2023-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#30 (2023-08-21;DOY=233)
if [ $resuming_from -eq 2023225 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-08-21 -e 2023-08-21 
  modis_collect --interleave --cleanup --last-collected 2023225 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023233 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-08d3 (#24)
  modis_window -b 2023-08-25 -e 2023-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-08d2 (#23)
  modis_window -b 2023-08-15 -e 2023-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-08d1 (#22)
  modis_window -b 2023-08-05 -e 2023-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#31 (2023-08-29;DOY=241)
if [ $resuming_from -eq 2023233 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-08-29 -e 2023-08-29 
  modis_collect --interleave --cleanup --last-collected 2023233 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023241 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-09d1 (#25)
  modis_window -b 2023-09-05 -e 2023-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-08d3 (#24)
  modis_window -b 2023-08-25 -e 2023-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-08d2 (#23)
  modis_window -b 2023-08-15 -e 2023-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#32 (2023-09-06;DOY=249)
if [ $resuming_from -eq 2023241 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-09-06 -e 2023-09-06 
  modis_collect --interleave --cleanup --last-collected 2023241 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023249 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-09d1 (#25)
  modis_window -b 2023-09-05 -e 2023-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-08d3 (#24)
  modis_window -b 2023-08-25 -e 2023-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#33 (2023-09-14;DOY=257)
if [ $resuming_from -eq 2023249 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-09-14 -e 2023-09-14 
  modis_collect --interleave --cleanup --last-collected 2023249 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023257 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-09d2 (#26)
  modis_window -b 2023-09-15 -e 2023-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-09d1 (#25)
  modis_window -b 2023-09-05 -e 2023-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#34 (2023-09-22;DOY=265)
if [ $resuming_from -eq 2023257 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-09-22 -e 2023-09-22 
  modis_collect --interleave --cleanup --last-collected 2023257 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023265 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-09d3 (#27)
  modis_window -b 2023-09-25 -e 2023-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-09d2 (#26)
  modis_window -b 2023-09-15 -e 2023-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#35 (2023-09-30;DOY=273)
if [ $resuming_from -eq 2023265 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-09-30 -e 2023-09-30 
  modis_collect --interleave --cleanup --last-collected 2023265 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023273 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-10d1 (#28)
  modis_window -b 2023-10-05 -e 2023-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-09d3 (#27)
  modis_window -b 2023-09-25 -e 2023-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-09d2 (#26)
  modis_window -b 2023-09-15 -e 2023-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#36 (2023-10-08;DOY=281)
if [ $resuming_from -eq 2023273 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-10-08 -e 2023-10-08 
  modis_collect --interleave --cleanup --last-collected 2023273 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023281 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-10d2 (#29)
  modis_window -b 2023-10-15 -e 2023-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-10d1 (#28)
  modis_window -b 2023-10-05 -e 2023-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-09d3 (#27)
  modis_window -b 2023-09-25 -e 2023-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#37 (2023-10-16;DOY=289)
if [ $resuming_from -eq 2023281 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-10-16 -e 2023-10-16 
  modis_collect --interleave --cleanup --last-collected 2023281 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023289 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-10d2 (#29)
  modis_window -b 2023-10-15 -e 2023-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-10d1 (#28)
  modis_window -b 2023-10-05 -e 2023-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#38 (2023-10-24;DOY=297)
if [ $resuming_from -eq 2023289 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-10-24 -e 2023-10-24 
  modis_collect --interleave --cleanup --last-collected 2023289 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023297 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-10d3 (#30)
  modis_window -b 2023-10-25 -e 2023-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-10d2 (#29)
  modis_window -b 2023-10-15 -e 2023-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#39 (2023-11-01;DOY=305)
if [ $resuming_from -eq 2023297 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-11-01 -e 2023-11-01 
  modis_collect --interleave --cleanup --last-collected 2023297 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023305 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-11d1 (#31)
  modis_window -b 2023-11-05 -e 2023-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-10d3 (#30)
  modis_window -b 2023-10-25 -e 2023-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#40 (2023-11-09;DOY=313)
if [ $resuming_from -eq 2023305 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-11-09 -e 2023-11-09 
  modis_collect --interleave --cleanup --last-collected 2023305 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023313 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-11d2 (#32)
  modis_window -b 2023-11-15 -e 2023-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-11d1 (#31)
  modis_window -b 2023-11-05 -e 2023-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-10d3 (#30)
  modis_window -b 2023-10-25 -e 2023-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#41 (2023-11-17;DOY=321)
if [ $resuming_from -eq 2023313 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-11-17 -e 2023-11-17 
  modis_collect --interleave --cleanup --last-collected 2023313 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023321 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-11d2 (#32)
  modis_window -b 2023-11-15 -e 2023-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-11d1 (#31)
  modis_window -b 2023-11-05 -e 2023-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#42 (2023-11-25;DOY=329)
if [ $resuming_from -eq 2023321 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-11-25 -e 2023-11-25 
  modis_collect --interleave --cleanup --last-collected 2023321 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023329 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-11d3 (#33)
  modis_window -b 2023-11-25 -e 2023-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-11d2 (#32)
  modis_window -b 2023-11-15 -e 2023-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#43 (2023-12-03;DOY=337)
if [ $resuming_from -eq 2023329 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-12-03 -e 2023-12-03 
  modis_collect --interleave --cleanup --last-collected 2023329 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2023337 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-12d1 (#34)
  modis_window -b 2023-12-05 -e 2023-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-11d3 (#33)
  modis_window -b 2023-11-25 -e 2023-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#44 (2023-12-11;DOY=345)
if [ $resuming_from -eq 2023337 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-12-11 -e 2023-12-11 
  modis_collect --interleave --cleanup --last-collected 2023337 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023345 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-12d2 (#35)
  modis_window -b 2023-12-15 -e 2023-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-12d1 (#34)
  modis_window -b 2023-12-05 -e 2023-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-11d3 (#33)
  modis_window -b 2023-11-25 -e 2023-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#45 (2023-12-19;DOY=353)
if [ $resuming_from -eq 2023345 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-12-19 -e 2023-12-19 
  modis_collect --interleave --cleanup --last-collected 2023345 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023353 -d ./VIM/SMOOTH ./VIM
  # CS0: 2023-12d3 (#36)
  modis_window -b 2023-12-25 -e 2023-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2023353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2023-12d2 (#35)
  modis_window -b 2023-12-15 -e 2023-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-12d1 (#34)
  modis_window -b 2023-12-05 -e 2023-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2023-OTD#46 (2023-12-27;DOY=361)
if [ $resuming_from -eq 2023353 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2023-12-27 -e 2023-12-27 
  modis_collect --interleave --cleanup --last-collected 2023353 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2023361 -d ./VIM/SMOOTH ./VIM
  # CS1: 2023-12d3 (#36)
  modis_window -b 2023-12-25 -e 2023-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2023361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-12d2 (#35)
  modis_window -b 2023-12-15 -e 2023-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2023361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#01 (2024-01-01;DOY=1)
if [ $resuming_from -eq 2023361 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-01-01 -e 2024-01-01 
  modis_collect --interleave --cleanup --last-collected 2023361 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024001 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-01d1 (#01)
  modis_window -b 2024-01-05 -e 2024-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2023-12d3 (#36)
  modis_window -b 2023-12-25 -e 2023-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#02 (2024-01-09;DOY=9)
if [ $resuming_from -eq 2024001 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-01-09 -e 2024-01-09 
  modis_collect --interleave --cleanup --last-collected 2024001 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024009 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-01d2 (#02)
  modis_window -b 2024-01-15 -e 2024-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-01d1 (#01)
  modis_window -b 2024-01-05 -e 2024-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#03 (2024-01-17;DOY=17)
if [ $resuming_from -eq 2024009 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-01-17 -e 2024-01-17 
  modis_collect --interleave --cleanup --last-collected 2024009 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024017 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-01d2 (#02)
  modis_window -b 2024-01-15 -e 2024-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-01d1 (#01)
  modis_window -b 2024-01-05 -e 2024-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#04 (2024-01-25;DOY=25)
if [ $resuming_from -eq 2024017 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-01-25 -e 2024-01-25 
  modis_collect --interleave --cleanup --last-collected 2024017 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024025 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-01d3 (#03)
  modis_window -b 2024-01-25 -e 2024-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-01d2 (#02)
  modis_window -b 2024-01-15 -e 2024-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#05 (2024-02-02;DOY=33)
if [ $resuming_from -eq 2024025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-02-02 -e 2024-02-02 
  modis_collect --interleave --cleanup --last-collected 2024025 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024033 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-02d1 (#04)
  modis_window -b 2024-02-05 -e 2024-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-01d3 (#03)
  modis_window -b 2024-01-25 -e 2024-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#06 (2024-02-10;DOY=41)
if [ $resuming_from -eq 2024033 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-02-10 -e 2024-02-10 
  modis_collect --interleave --cleanup --last-collected 2024033 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024041 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-02d2 (#05)
  modis_window -b 2024-02-15 -e 2024-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-02d1 (#04)
  modis_window -b 2024-02-05 -e 2024-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-01d3 (#03)
  modis_window -b 2024-01-25 -e 2024-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#07 (2024-02-18;DOY=49)
if [ $resuming_from -eq 2024041 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-02-18 -e 2024-02-18 
  modis_collect --interleave --cleanup --last-collected 2024041 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024049 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-02d3 (#06)
  modis_window -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-02d2 (#05)
  modis_window -b 2024-02-15 -e 2024-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-02d1 (#04)
  modis_window -b 2024-02-05 -e 2024-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#08 (2024-02-26;DOY=57)
if [ $resuming_from -eq 2024049 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-02-26 -e 2024-02-26 
  modis_collect --interleave --cleanup --last-collected 2024049 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024057 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-02d3 (#06)
  modis_window -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-02d2 (#05)
  modis_window -b 2024-02-15 -e 2024-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#09 (2024-03-05;DOY=65)
if [ $resuming_from -eq 2024057 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-05 -e 2024-03-05 
  modis_collect --interleave --cleanup --last-collected 2024057 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024065 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-03d1 (#07)
  modis_window -b 2024-03-05 -e 2024-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-02d3 (#06)
  modis_window -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#10 (2024-03-13;DOY=73)
if [ $resuming_from -eq 2024065 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-13 -e 2024-03-13 
  modis_collect --interleave --cleanup --last-collected 2024065 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024073 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-03d2 (#08)
  modis_window -b 2024-03-15 -e 2024-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-03d1 (#07)
  modis_window -b 2024-03-05 -e 2024-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#11 (2024-03-21;DOY=81)
if [ $resuming_from -eq 2024073 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-21 -e 2024-03-21 
  modis_collect --interleave --cleanup --last-collected 2024073 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024081 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-03d3 (#09)
  modis_window -b 2024-03-25 -e 2024-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-03d2 (#08)
  modis_window -b 2024-03-15 -e 2024-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-03d1 (#07)
  modis_window -b 2024-03-05 -e 2024-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#12 (2024-03-29;DOY=89)
if [ $resuming_from -eq 2024081 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-03-29 -e 2024-03-29 
  modis_collect --interleave --cleanup --last-collected 2024081 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024089 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-04d1 (#10)
  modis_window -b 2024-04-05 -e 2024-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-03d3 (#09)
  modis_window -b 2024-03-25 -e 2024-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-03d2 (#08)
  modis_window -b 2024-03-15 -e 2024-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#13 (2024-04-06;DOY=97)
if [ $resuming_from -eq 2024089 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-04-06 -e 2024-04-06 
  modis_collect --interleave --cleanup --last-collected 2024089 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024097 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-04d1 (#10)
  modis_window -b 2024-04-05 -e 2024-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-03d3 (#09)
  modis_window -b 2024-03-25 -e 2024-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#14 (2024-04-14;DOY=105)
if [ $resuming_from -eq 2024097 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-04-14 -e 2024-04-14 
  modis_collect --interleave --cleanup --last-collected 2024097 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024105 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-04d2 (#11)
  modis_window -b 2024-04-15 -e 2024-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-04d1 (#10)
  modis_window -b 2024-04-05 -e 2024-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#15 (2024-04-22;DOY=113)
if [ $resuming_from -eq 2024105 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-04-22 -e 2024-04-22 
  modis_collect --interleave --cleanup --last-collected 2024105 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024113 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-04d3 (#12)
  modis_window -b 2024-04-25 -e 2024-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-04d2 (#11)
  modis_window -b 2024-04-15 -e 2024-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#16 (2024-04-30;DOY=121)
if [ $resuming_from -eq 2024113 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-04-30 -e 2024-04-30 
  modis_collect --interleave --cleanup --last-collected 2024113 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024121 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-05d1 (#13)
  modis_window -b 2024-05-05 -e 2024-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-04d3 (#12)
  modis_window -b 2024-04-25 -e 2024-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-04d2 (#11)
  modis_window -b 2024-04-15 -e 2024-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#17 (2024-05-08;DOY=129)
if [ $resuming_from -eq 2024121 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-05-08 -e 2024-05-08 
  modis_collect --interleave --cleanup --last-collected 2024121 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024129 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-05d2 (#14)
  modis_window -b 2024-05-15 -e 2024-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-05d1 (#13)
  modis_window -b 2024-05-05 -e 2024-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-04d3 (#12)
  modis_window -b 2024-04-25 -e 2024-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#18 (2024-05-16;DOY=137)
if [ $resuming_from -eq 2024129 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-05-16 -e 2024-05-16 
  modis_collect --interleave --cleanup --last-collected 2024129 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024137 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-05d2 (#14)
  modis_window -b 2024-05-15 -e 2024-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-05d1 (#13)
  modis_window -b 2024-05-05 -e 2024-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#19 (2024-05-24;DOY=145)
if [ $resuming_from -eq 2024137 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-05-24 -e 2024-05-24 
  modis_collect --interleave --cleanup --last-collected 2024137 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024145 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-05d3 (#15)
  modis_window -b 2024-05-25 -e 2024-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-05d2 (#14)
  modis_window -b 2024-05-15 -e 2024-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#20 (2024-06-01;DOY=153)
if [ $resuming_from -eq 2024145 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-06-01 -e 2024-06-01 
  modis_collect --interleave --cleanup --last-collected 2024145 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024153 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-06d1 (#16)
  modis_window -b 2024-06-05 -e 2024-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-05d3 (#15)
  modis_window -b 2024-05-25 -e 2024-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#21 (2024-06-09;DOY=161)
if [ $resuming_from -eq 2024153 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-06-09 -e 2024-06-09 
  modis_collect --interleave --cleanup --last-collected 2024153 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024161 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-06d2 (#17)
  modis_window -b 2024-06-15 -e 2024-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-06d1 (#16)
  modis_window -b 2024-06-05 -e 2024-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-05d3 (#15)
  modis_window -b 2024-05-25 -e 2024-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#22 (2024-06-17;DOY=169)
if [ $resuming_from -eq 2024161 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-06-17 -e 2024-06-17 
  modis_collect --interleave --cleanup --last-collected 2024161 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024169 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-06d2 (#17)
  modis_window -b 2024-06-15 -e 2024-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-06d1 (#16)
  modis_window -b 2024-06-05 -e 2024-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#23 (2024-06-25;DOY=177)
if [ $resuming_from -eq 2024169 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-06-25 -e 2024-06-25 
  modis_collect --interleave --cleanup --last-collected 2024169 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024177 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-06d3 (#18)
  modis_window -b 2024-06-25 -e 2024-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-06d2 (#17)
  modis_window -b 2024-06-15 -e 2024-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#24 (2024-07-03;DOY=185)
if [ $resuming_from -eq 2024177 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-07-03 -e 2024-07-03 
  modis_collect --interleave --cleanup --last-collected 2024177 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024185 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-07d1 (#19)
  modis_window -b 2024-07-05 -e 2024-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-06d3 (#18)
  modis_window -b 2024-06-25 -e 2024-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#25 (2024-07-11;DOY=193)
if [ $resuming_from -eq 2024185 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-07-11 -e 2024-07-11 
  modis_collect --interleave --cleanup --last-collected 2024185 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024193 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-07d2 (#20)
  modis_window -b 2024-07-15 -e 2024-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-07d1 (#19)
  modis_window -b 2024-07-05 -e 2024-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-06d3 (#18)
  modis_window -b 2024-06-25 -e 2024-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#26 (2024-07-19;DOY=201)
if [ $resuming_from -eq 2024193 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-07-19 -e 2024-07-19 
  modis_collect --interleave --cleanup --last-collected 2024193 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024201 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-07d3 (#21)
  modis_window -b 2024-07-25 -e 2024-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-07d2 (#20)
  modis_window -b 2024-07-15 -e 2024-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-07d1 (#19)
  modis_window -b 2024-07-05 -e 2024-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#27 (2024-07-27;DOY=209)
if [ $resuming_from -eq 2024201 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-07-27 -e 2024-07-27 
  modis_collect --interleave --cleanup --last-collected 2024201 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024209 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-07d3 (#21)
  modis_window -b 2024-07-25 -e 2024-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-07d2 (#20)
  modis_window -b 2024-07-15 -e 2024-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#28 (2024-08-04;DOY=217)
if [ $resuming_from -eq 2024209 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-08-04 -e 2024-08-04 
  modis_collect --interleave --cleanup --last-collected 2024209 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024217 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-08d1 (#22)
  modis_window -b 2024-08-05 -e 2024-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-07d3 (#21)
  modis_window -b 2024-07-25 -e 2024-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#29 (2024-08-12;DOY=225)
if [ $resuming_from -eq 2024217 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-08-12 -e 2024-08-12 
  modis_collect --interleave --cleanup --last-collected 2024217 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024225 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-08d2 (#23)
  modis_window -b 2024-08-15 -e 2024-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-08d1 (#22)
  modis_window -b 2024-08-05 -e 2024-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#30 (2024-08-20;DOY=233)
if [ $resuming_from -eq 2024225 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-08-20 -e 2024-08-20 
  modis_collect --interleave --cleanup --last-collected 2024225 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024233 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-08d3 (#24)
  modis_window -b 2024-08-25 -e 2024-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-08d2 (#23)
  modis_window -b 2024-08-15 -e 2024-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-08d1 (#22)
  modis_window -b 2024-08-05 -e 2024-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#31 (2024-08-28;DOY=241)
if [ $resuming_from -eq 2024233 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-08-28 -e 2024-08-28 
  modis_collect --interleave --cleanup --last-collected 2024233 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024241 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-08d3 (#24)
  modis_window -b 2024-08-25 -e 2024-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-08d2 (#23)
  modis_window -b 2024-08-15 -e 2024-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#32 (2024-09-05;DOY=249)
if [ $resuming_from -eq 2024241 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-09-05 -e 2024-09-05 
  modis_collect --interleave --cleanup --last-collected 2024241 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024249 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-09d1 (#25)
  modis_window -b 2024-09-05 -e 2024-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-08d3 (#24)
  modis_window -b 2024-08-25 -e 2024-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#33 (2024-09-13;DOY=257)
if [ $resuming_from -eq 2024249 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-09-13 -e 2024-09-13 
  modis_collect --interleave --cleanup --last-collected 2024249 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024257 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-09d2 (#26)
  modis_window -b 2024-09-15 -e 2024-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-09d1 (#25)
  modis_window -b 2024-09-05 -e 2024-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#34 (2024-09-21;DOY=265)
if [ $resuming_from -eq 2024257 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-09-21 -e 2024-09-21 
  modis_collect --interleave --cleanup --last-collected 2024257 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024265 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-09d3 (#27)
  modis_window -b 2024-09-25 -e 2024-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-09d2 (#26)
  modis_window -b 2024-09-15 -e 2024-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-09d1 (#25)
  modis_window -b 2024-09-05 -e 2024-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#35 (2024-09-29;DOY=273)
if [ $resuming_from -eq 2024265 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-09-29 -e 2024-09-29 
  modis_collect --interleave --cleanup --last-collected 2024265 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024273 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-10d1 (#28)
  modis_window -b 2024-10-05 -e 2024-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-09d3 (#27)
  modis_window -b 2024-09-25 -e 2024-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-09d2 (#26)
  modis_window -b 2024-09-15 -e 2024-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#36 (2024-10-07;DOY=281)
if [ $resuming_from -eq 2024273 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-10-07 -e 2024-10-07 
  modis_collect --interleave --cleanup --last-collected 2024273 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024281 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-10d1 (#28)
  modis_window -b 2024-10-05 -e 2024-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-09d3 (#27)
  modis_window -b 2024-09-25 -e 2024-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#37 (2024-10-15;DOY=289)
if [ $resuming_from -eq 2024281 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-10-15 -e 2024-10-15 
  modis_collect --interleave --cleanup --last-collected 2024281 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024289 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-10d2 (#29)
  modis_window -b 2024-10-15 -e 2024-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-10d1 (#28)
  modis_window -b 2024-10-05 -e 2024-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#38 (2024-10-23;DOY=297)
if [ $resuming_from -eq 2024289 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-10-23 -e 2024-10-23 
  modis_collect --interleave --cleanup --last-collected 2024289 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024297 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-10d3 (#30)
  modis_window -b 2024-10-25 -e 2024-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-10d2 (#29)
  modis_window -b 2024-10-15 -e 2024-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#39 (2024-10-31;DOY=305)
if [ $resuming_from -eq 2024297 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-10-31 -e 2024-10-31 
  modis_collect --interleave --cleanup --last-collected 2024297 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024305 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-11d1 (#31)
  modis_window -b 2024-11-05 -e 2024-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-10d3 (#30)
  modis_window -b 2024-10-25 -e 2024-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-10d2 (#29)
  modis_window -b 2024-10-15 -e 2024-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#40 (2024-11-08;DOY=313)
if [ $resuming_from -eq 2024305 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-11-08 -e 2024-11-08 
  modis_collect --interleave --cleanup --last-collected 2024305 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024313 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-11d2 (#32)
  modis_window -b 2024-11-15 -e 2024-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-11d1 (#31)
  modis_window -b 2024-11-05 -e 2024-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-10d3 (#30)
  modis_window -b 2024-10-25 -e 2024-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#41 (2024-11-16;DOY=321)
if [ $resuming_from -eq 2024313 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-11-16 -e 2024-11-16 
  modis_collect --interleave --cleanup --last-collected 2024313 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024321 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-11d2 (#32)
  modis_window -b 2024-11-15 -e 2024-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-11d1 (#31)
  modis_window -b 2024-11-05 -e 2024-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#42 (2024-11-24;DOY=329)
if [ $resuming_from -eq 2024321 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-11-24 -e 2024-11-24 
  modis_collect --interleave --cleanup --last-collected 2024321 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024329 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-11d3 (#33)
  modis_window -b 2024-11-25 -e 2024-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-11d2 (#32)
  modis_window -b 2024-11-15 -e 2024-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#43 (2024-12-02;DOY=337)
if [ $resuming_from -eq 2024329 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-12-02 -e 2024-12-02 
  modis_collect --interleave --cleanup --last-collected 2024329 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2024337 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-12d1 (#34)
  modis_window -b 2024-12-05 -e 2024-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-11d3 (#33)
  modis_window -b 2024-11-25 -e 2024-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#44 (2024-12-10;DOY=345)
if [ $resuming_from -eq 2024337 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-12-10 -e 2024-12-10 
  modis_collect --interleave --cleanup --last-collected 2024337 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024345 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-12d2 (#35)
  modis_window -b 2024-12-15 -e 2024-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-12d1 (#34)
  modis_window -b 2024-12-05 -e 2024-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-11d3 (#33)
  modis_window -b 2024-11-25 -e 2024-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#45 (2024-12-18;DOY=353)
if [ $resuming_from -eq 2024345 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-12-18 -e 2024-12-18 
  modis_collect --interleave --cleanup --last-collected 2024345 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024353 -d ./VIM/SMOOTH ./VIM
  # CS0: 2024-12d3 (#36)
  modis_window -b 2024-12-25 -e 2024-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2024353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2024-12d2 (#35)
  modis_window -b 2024-12-15 -e 2024-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-12d1 (#34)
  modis_window -b 2024-12-05 -e 2024-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2024-OTD#46 (2024-12-26;DOY=361)
if [ $resuming_from -eq 2024353 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-12-26 -e 2024-12-26 
  modis_collect --interleave --cleanup --last-collected 2024353 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2024361 -d ./VIM/SMOOTH ./VIM
  # CS1: 2024-12d3 (#36)
  modis_window -b 2024-12-25 -e 2024-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2024361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-12d2 (#35)
  modis_window -b 2024-12-15 -e 2024-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2024361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#01 (2025-01-01;DOY=1)
if [ $resuming_from -eq 2024361 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-01-01 -e 2025-01-01 
  modis_collect --interleave --cleanup --last-collected 2024361 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025001 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-01d1 (#01)
  modis_window -b 2025-01-05 -e 2025-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2024-12d3 (#36)
  modis_window -b 2024-12-25 -e 2024-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#02 (2025-01-09;DOY=9)
if [ $resuming_from -eq 2025001 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-01-09 -e 2025-01-09 
  modis_collect --interleave --cleanup --last-collected 2025001 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025009 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-01d2 (#02)
  modis_window -b 2025-01-15 -e 2025-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-01d1 (#01)
  modis_window -b 2025-01-05 -e 2025-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#03 (2025-01-17;DOY=17)
if [ $resuming_from -eq 2025009 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-01-17 -e 2025-01-17 
  modis_collect --interleave --cleanup --last-collected 2025009 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025017 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-01d2 (#02)
  modis_window -b 2025-01-15 -e 2025-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-01d1 (#01)
  modis_window -b 2025-01-05 -e 2025-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#04 (2025-01-25;DOY=25)
if [ $resuming_from -eq 2025017 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-01-25 -e 2025-01-25 
  modis_collect --interleave --cleanup --last-collected 2025017 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025025 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-01d3 (#03)
  modis_window -b 2025-01-25 -e 2025-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-01d2 (#02)
  modis_window -b 2025-01-15 -e 2025-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#05 (2025-02-02;DOY=33)
if [ $resuming_from -eq 2025025 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-02-02 -e 2025-02-02 
  modis_collect --interleave --cleanup --last-collected 2025025 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025033 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-02d1 (#04)
  modis_window -b 2025-02-05 -e 2025-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-01d3 (#03)
  modis_window -b 2025-01-25 -e 2025-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#06 (2025-02-10;DOY=41)
if [ $resuming_from -eq 2025033 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-02-10 -e 2025-02-10 
  modis_collect --interleave --cleanup --last-collected 2025033 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025041 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-02d2 (#05)
  modis_window -b 2025-02-15 -e 2025-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-02d1 (#04)
  modis_window -b 2025-02-05 -e 2025-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-01d3 (#03)
  modis_window -b 2025-01-25 -e 2025-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025041 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#07 (2025-02-18;DOY=49)
if [ $resuming_from -eq 2025041 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-02-18 -e 2025-02-18 
  modis_collect --interleave --cleanup --last-collected 2025041 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025049 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-02d3 (#06)
  modis_window -b 2025-02-25 -e 2025-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-02d2 (#05)
  modis_window -b 2025-02-15 -e 2025-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-02d1 (#04)
  modis_window -b 2025-02-05 -e 2025-02-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#08 (2025-02-26;DOY=57)
if [ $resuming_from -eq 2025049 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-02-26 -e 2025-02-26 
  modis_collect --interleave --cleanup --last-collected 2025049 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025057 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-03d1 (#07)
  modis_window -b 2025-03-05 -e 2025-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-02d3 (#06)
  modis_window -b 2025-02-25 -e 2025-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-02d2 (#05)
  modis_window -b 2025-02-15 -e 2025-02-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#09 (2025-03-06;DOY=65)
if [ $resuming_from -eq 2025057 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-03-06 -e 2025-03-06 
  modis_collect --interleave --cleanup --last-collected 2025057 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025065 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-03d1 (#07)
  modis_window -b 2025-03-05 -e 2025-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-02d3 (#06)
  modis_window -b 2025-02-25 -e 2025-02-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025065 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#10 (2025-03-14;DOY=73)
if [ $resuming_from -eq 2025065 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-03-14 -e 2025-03-14 
  modis_collect --interleave --cleanup --last-collected 2025065 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025073 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-03d2 (#08)
  modis_window -b 2025-03-15 -e 2025-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-03d1 (#07)
  modis_window -b 2025-03-05 -e 2025-03-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025073 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#11 (2025-03-22;DOY=81)
if [ $resuming_from -eq 2025073 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-03-22 -e 2025-03-22 
  modis_collect --interleave --cleanup --last-collected 2025073 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025081 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-03d3 (#09)
  modis_window -b 2025-03-25 -e 2025-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-03d2 (#08)
  modis_window -b 2025-03-15 -e 2025-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025081 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#12 (2025-03-30;DOY=89)
if [ $resuming_from -eq 2025081 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-03-30 -e 2025-03-30 
  modis_collect --interleave --cleanup --last-collected 2025081 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025089 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-04d1 (#10)
  modis_window -b 2025-04-05 -e 2025-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-03d3 (#09)
  modis_window -b 2025-03-25 -e 2025-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-03d2 (#08)
  modis_window -b 2025-03-15 -e 2025-03-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025089 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#13 (2025-04-07;DOY=97)
if [ $resuming_from -eq 2025089 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-04-07 -e 2025-04-07 
  modis_collect --interleave --cleanup --last-collected 2025089 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025097 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-04d1 (#10)
  modis_window -b 2025-04-05 -e 2025-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-03d3 (#09)
  modis_window -b 2025-03-25 -e 2025-03-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025097 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#14 (2025-04-15;DOY=105)
if [ $resuming_from -eq 2025097 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-04-15 -e 2025-04-15 
  modis_collect --interleave --cleanup --last-collected 2025097 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025105 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-04d2 (#11)
  modis_window -b 2025-04-15 -e 2025-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-04d1 (#10)
  modis_window -b 2025-04-05 -e 2025-04-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025105 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#15 (2025-04-23;DOY=113)
if [ $resuming_from -eq 2025105 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-04-23 -e 2025-04-23 
  modis_collect --interleave --cleanup --last-collected 2025105 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025113 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-04d3 (#12)
  modis_window -b 2025-04-25 -e 2025-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-04d2 (#11)
  modis_window -b 2025-04-15 -e 2025-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025113 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#16 (2025-05-01;DOY=121)
if [ $resuming_from -eq 2025113 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-05-01 -e 2025-05-01 
  modis_collect --interleave --cleanup --last-collected 2025113 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025121 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-05d1 (#13)
  modis_window -b 2025-05-05 -e 2025-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-04d3 (#12)
  modis_window -b 2025-04-25 -e 2025-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-04d2 (#11)
  modis_window -b 2025-04-15 -e 2025-04-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025121 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#17 (2025-05-09;DOY=129)
if [ $resuming_from -eq 2025121 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-05-09 -e 2025-05-09 
  modis_collect --interleave --cleanup --last-collected 2025121 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025129 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-05d2 (#14)
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-05d1 (#13)
  modis_window -b 2025-05-05 -e 2025-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-04d3 (#12)
  modis_window -b 2025-04-25 -e 2025-04-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025129 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#18 (2025-05-17;DOY=137)
if [ $resuming_from -eq 2025129 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-05-17 -e 2025-05-17 
  modis_collect --interleave --cleanup --last-collected 2025129 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025137 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-05d2 (#14)
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-05d1 (#13)
  modis_window -b 2025-05-05 -e 2025-05-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025137 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#19 (2025-05-25;DOY=145)
if [ $resuming_from -eq 2025137 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-05-25 -e 2025-05-25 
  modis_collect --interleave --cleanup --last-collected 2025137 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025145 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-05d3 (#15)
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-05d2 (#14)
  modis_window -b 2025-05-15 -e 2025-05-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025145 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#20 (2025-06-02;DOY=153)
if [ $resuming_from -eq 2025145 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-06-02 -e 2025-06-02 
  modis_collect --interleave --cleanup --last-collected 2025145 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025153 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-06d1 (#16)
  modis_window -b 2025-06-05 -e 2025-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-05d3 (#15)
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025153 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#21 (2025-06-10;DOY=161)
if [ $resuming_from -eq 2025153 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-06-10 -e 2025-06-10 
  modis_collect --interleave --cleanup --last-collected 2025153 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025161 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-06d2 (#17)
  modis_window -b 2025-06-15 -e 2025-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-06d1 (#16)
  modis_window -b 2025-06-05 -e 2025-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-05d3 (#15)
  modis_window -b 2025-05-25 -e 2025-05-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025161 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#22 (2025-06-18;DOY=169)
if [ $resuming_from -eq 2025161 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-06-18 -e 2025-06-18 
  modis_collect --interleave --cleanup --last-collected 2025161 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025169 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-06d3 (#18)
  modis_window -b 2025-06-25 -e 2025-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-06d2 (#17)
  modis_window -b 2025-06-15 -e 2025-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-06d1 (#16)
  modis_window -b 2025-06-05 -e 2025-06-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025169 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#23 (2025-06-26;DOY=177)
if [ $resuming_from -eq 2025169 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-06-26 -e 2025-06-26 
  modis_collect --interleave --cleanup --last-collected 2025169 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025177 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-06d3 (#18)
  modis_window -b 2025-06-25 -e 2025-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-06d2 (#17)
  modis_window -b 2025-06-15 -e 2025-06-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025177 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#24 (2025-07-04;DOY=185)
if [ $resuming_from -eq 2025177 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-07-04 -e 2025-07-04 
  modis_collect --interleave --cleanup --last-collected 2025177 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025185 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-07d1 (#19)
  modis_window -b 2025-07-05 -e 2025-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-06d3 (#18)
  modis_window -b 2025-06-25 -e 2025-06-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025185 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#25 (2025-07-12;DOY=193)
if [ $resuming_from -eq 2025185 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-07-12 -e 2025-07-12 
  modis_collect --interleave --cleanup --last-collected 2025185 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025193 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-07d2 (#20)
  modis_window -b 2025-07-15 -e 2025-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-07d1 (#19)
  modis_window -b 2025-07-05 -e 2025-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025193 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#26 (2025-07-20;DOY=201)
if [ $resuming_from -eq 2025193 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-07-20 -e 2025-07-20 
  modis_collect --interleave --cleanup --last-collected 2025193 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025201 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-07d3 (#21)
  modis_window -b 2025-07-25 -e 2025-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-07d2 (#20)
  modis_window -b 2025-07-15 -e 2025-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-07d1 (#19)
  modis_window -b 2025-07-05 -e 2025-07-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025201 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#27 (2025-07-28;DOY=209)
if [ $resuming_from -eq 2025201 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-07-28 -e 2025-07-28 
  modis_collect --interleave --cleanup --last-collected 2025201 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025209 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-07d3 (#21)
  modis_window -b 2025-07-25 -e 2025-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-07d2 (#20)
  modis_window -b 2025-07-15 -e 2025-07-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025209 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#28 (2025-08-05;DOY=217)
if [ $resuming_from -eq 2025209 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-08-05 -e 2025-08-05 
  modis_collect --interleave --cleanup --last-collected 2025209 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025217 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-08d1 (#22)
  modis_window -b 2025-08-05 -e 2025-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-07d3 (#21)
  modis_window -b 2025-07-25 -e 2025-07-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025217 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#29 (2025-08-13;DOY=225)
if [ $resuming_from -eq 2025217 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-08-13 -e 2025-08-13 
  modis_collect --interleave --cleanup --last-collected 2025217 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025225 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-08d2 (#23)
  modis_window -b 2025-08-15 -e 2025-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-08d1 (#22)
  modis_window -b 2025-08-05 -e 2025-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025225 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#30 (2025-08-21;DOY=233)
if [ $resuming_from -eq 2025225 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-08-21 -e 2025-08-21 
  modis_collect --interleave --cleanup --last-collected 2025225 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025233 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-08d3 (#24)
  modis_window -b 2025-08-25 -e 2025-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-08d2 (#23)
  modis_window -b 2025-08-15 -e 2025-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-08d1 (#22)
  modis_window -b 2025-08-05 -e 2025-08-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025233 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#31 (2025-08-29;DOY=241)
if [ $resuming_from -eq 2025233 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-08-29 -e 2025-08-29 
  modis_collect --interleave --cleanup --last-collected 2025233 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025241 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-09d1 (#25)
  modis_window -b 2025-09-05 -e 2025-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-08d3 (#24)
  modis_window -b 2025-08-25 -e 2025-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-08d2 (#23)
  modis_window -b 2025-08-15 -e 2025-08-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025241 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#32 (2025-09-06;DOY=249)
if [ $resuming_from -eq 2025241 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-09-06 -e 2025-09-06 
  modis_collect --interleave --cleanup --last-collected 2025241 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025249 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-09d1 (#25)
  modis_window -b 2025-09-05 -e 2025-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-08d3 (#24)
  modis_window -b 2025-08-25 -e 2025-08-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025249 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#33 (2025-09-14;DOY=257)
if [ $resuming_from -eq 2025249 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-09-14 -e 2025-09-14 
  modis_collect --interleave --cleanup --last-collected 2025249 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025257 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-09d2 (#26)
  modis_window -b 2025-09-15 -e 2025-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-09d1 (#25)
  modis_window -b 2025-09-05 -e 2025-09-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025257 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#34 (2025-09-22;DOY=265)
if [ $resuming_from -eq 2025257 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-09-22 -e 2025-09-22 
  modis_collect --interleave --cleanup --last-collected 2025257 .
  modis_smooth --nsmooth 64 --nupdate 2 \
    --tempint 10 --last-collected 2025265 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-09d3 (#27)
  modis_window -b 2025-09-25 -e 2025-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-09d2 (#26)
  modis_window -b 2025-09-15 -e 2025-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025265 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#35 (2025-09-30;DOY=273)
if [ $resuming_from -eq 2025265 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-09-30 -e 2025-09-30 
  modis_collect --interleave --cleanup --last-collected 2025265 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025273 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-10d1 (#28)
  modis_window -b 2025-10-05 -e 2025-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-09d3 (#27)
  modis_window -b 2025-09-25 -e 2025-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-09d2 (#26)
  modis_window -b 2025-09-15 -e 2025-09-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025273 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#36 (2025-10-08;DOY=281)
if [ $resuming_from -eq 2025273 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-10-08 -e 2025-10-08 
  modis_collect --interleave --cleanup --last-collected 2025273 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025281 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-10d2 (#29)
  modis_window -b 2025-10-15 -e 2025-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-10d1 (#28)
  modis_window -b 2025-10-05 -e 2025-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-09d3 (#27)
  modis_window -b 2025-09-25 -e 2025-09-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025281 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#37 (2025-10-16;DOY=289)
if [ $resuming_from -eq 2025281 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-10-16 -e 2025-10-16 
  modis_collect --interleave --cleanup --last-collected 2025281 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025289 -d ./VIM/SMOOTH ./VIM
  # CS1: 2025-10d2 (#29)
  modis_window -b 2025-10-15 -e 2025-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-10d1 (#28)
  modis_window -b 2025-10-05 -e 2025-10-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025289 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#38 (2025-10-24;DOY=297)
if [ $resuming_from -eq 2025289 ]
then
  modis_download --download --multithread \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2025-10-24 -e 2025-10-24 
  modis_collect --interleave --cleanup --last-collected 2025289 .
  modis_smooth --nsmooth 64 --nupdate 3 \
    --tempint 10 --last-collected 2025297 -d ./VIM/SMOOTH ./VIM
  # CS0: 2025-10d3 (#30)
  modis_window -b 2025-10-25 -e 2025-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-10d2 (#29)
  modis_window -b 2025-10-15 -e 2025-10-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025297 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#39 (2025-11-01;DOY=305)
if [ $resuming_from -eq 2025297 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-10d3 (#30)
  modis_window -b 2025-10-25 -e 2025-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025305 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#40 (2025-11-09;DOY=313)
if [ $resuming_from -eq 2025305 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-11d1 (#31)
  modis_window -b 2025-11-05 -e 2025-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-10d3 (#30)
  modis_window -b 2025-10-25 -e 2025-10-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025313 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#41 (2025-11-17;DOY=321)
if [ $resuming_from -eq 2025313 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-11d1 (#31)
  modis_window -b 2025-11-05 -e 2025-11-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025321 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#42 (2025-11-25;DOY=329)
if [ $resuming_from -eq 2025321 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-11d2 (#32)
  modis_window -b 2025-11-15 -e 2025-11-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025329 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#43 (2025-12-03;DOY=337)
if [ $resuming_from -eq 2025329 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-11d3 (#33)
  modis_window -b 2025-11-25 -e 2025-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025337 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#44 (2025-12-11;DOY=345)
if [ $resuming_from -eq 2025337 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-12d1 (#34)
  modis_window -b 2025-12-05 -e 2025-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-11d3 (#33)
  modis_window -b 2025-11-25 -e 2025-11-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025345 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#45 (2025-12-19;DOY=353)
if [ $resuming_from -eq 2025345 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2025353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2025-12d2 (#35)
  modis_window -b 2025-12-15 -e 2025-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-12d1 (#34)
  modis_window -b 2025-12-05 -e 2025-12-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025353 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2025-OTD#46 (2025-12-27;DOY=361)
if [ $resuming_from -eq 2025353 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2025361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-12d2 (#35)
  modis_window -b 2025-12-15 -e 2025-12-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2025361 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2026-OTD#01 (2026-01-01;DOY=1)
if [ $resuming_from -eq 2025361 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2025-12d3 (#36)
  modis_window -b 2025-12-25 -e 2025-12-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026001 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2026-OTD#02 (2026-01-09;DOY=9)
if [ $resuming_from -eq 2026001 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-01d1 (#01)
  modis_window -b 2026-01-05 -e 2026-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026009 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2026-OTD#03 (2026-01-17;DOY=17)
if [ $resuming_from -eq 2026009 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-01d1 (#01)
  modis_window -b 2026-01-05 -e 2026-01-05 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026017 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2026-OTD#04 (2026-01-25;DOY=25)
if [ $resuming_from -eq 2026017 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS2: 2026-01d2 (#02)
  modis_window -b 2026-01-15 -e 2026-01-15 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=2&FINAL=TRUE" \
    --overwrite --last-smoothed 2026025 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
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
fi

# C: Processing of 2026-OTD#05 (2026-02-02;DOY=33)
if [ $resuming_from -eq 2026025 ]
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
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=0&FINAL=FALSE" \
    --overwrite --last-smoothed 2026033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
  # CS1: 2026-01d3 (#03)
  modis_window -b 2026-01-25 -e 2026-01-25 --clip-valid --round-int 2 \
    --roi -26.0,-35.0,60.0,38.0 --region AFRICA \
    --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --gdal-kwarg "metadataOptions=CONSOLIDATION_STAGE=1&FINAL=FALSE" \
    --overwrite --last-smoothed 2026033 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
fi
