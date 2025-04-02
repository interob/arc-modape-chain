
Export with Africa extents:
```
python modis_window.py -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 --region SOM \
    --roi -26.0,-35.0,60.0,38.0 --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --last-smoothed 2024049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
```

Export with Somalia extents:
```
python modis_window.py -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 --region MOS \
    --roi 40.0,-2.0,52.0,12.0 --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --last-smoothed 2024049 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
```

Export from chain:
```
python modis_window.py -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 --region SOM \
    --roi -26.0,-35.0,60.0,38.0 --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --last-smoothed 2024049 -d /private/arc-modape-somalia/chain/VIM/SMOOTH/EXPORT /private/arc-modape-somalia/chain/VIM/SMOOTH
```

Scripted forward processing:
```
export TILES="h22v07,h22v08,h22v09,h23v07,h23v07,h23v08"
export CMR_USERNAME="africanriskcapacity"
export CMR_PASSWORD="Nasa4ARC!"
python modis_download.py --download --multithread \
    --mirror /private/arc-modape-somalia/mirror \
    --username=$CMR_USERNAME --password=$CMR_PASSWORD \
    --robust --target-empty --match-begin --tile-filter $TILES \
    --collection 061 -b 2024-02-26 -e 2024-02-26 M?D13A2
python modis_collect.py --interleave --cleanup --last-collected 2024049 .
python modis_smooth.py --nsmooth 64 --nupdate 6 --tempint 10 \
    --last-collected 2024057 -d ./VIM/SMOOTH ./VIM
python modis_window.py -b 2024-02-25 -e 2024-02-25 --clip-valid --round-int 2 --region FWD \
    --roi 40.0,-2.0,52.0,12.0 --gdal-kwarg xRes=0.01 --gdal-kwarg yRes=0.01 \
    --last-smoothed 2024057 -d ./VIM/SMOOTH/EXPORT ./VIM/SMOOTH
```