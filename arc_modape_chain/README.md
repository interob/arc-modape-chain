The ARC MODAPE Filtered NDVI Processing Chain is developed in Python 3, building on the WFP VAM MODAPE toolkit.

For development, basically the same environment is needed as for production. Open a command line window / terminal in the directory 
you intend to work in; then issue the following commands:

  python -m venv .venv
  source .venv/bin/activate
  pip install --upgrade pip
  
Then, clone the WFP-VAM's modape repo; do editable install:

  git clone https://github.com/WFP-VAM/modape.git modape
  git -C ./modape checkout tags/v1.2.0 -b modape-v1.2.0
  pip install -e ./modape[dev]

Finally, clone and do an editable install of ARC MODAPE Filtered NDVI Processing Chain:
(./src is assumed to contain the source code)

  pip install -e ./src


Python FILES
------------
- arc_modis_ndvi.py -- actual processing chain (if you don't know where to start working on the MODIS processing, start here)

Scripts
-------
- modape_calendar.py -- utility script to produce the Release Calendar and MODAPE CLI parameters
- arc_modape_run.sh -- bootstrapper script to run another script (in $PWD) in a docker container
- policy_dataset_test.sh -- script to reproduce the policy dataset (starting from line 19, this script is in the policy annex)
- arc_modape_bash.sh -- start a terminal session in the docker container
- 