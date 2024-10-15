#!/bin/bash
export PYTHONUNBUFFERED=1
python /arc-modape-chain/src/chain/arc_modape_chain.py --config /arc-modape-chain/src/chain/Somalia.json init --download-only
