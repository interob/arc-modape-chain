docker compose up -d
docker compose exec engine /bin/bash
git clone https://github.com/WFP-VAM/modape.git modape
git -C ./modape checkout tags/v1.2.0 -b modape-v1.2.0
pip install -e ./modape[dev]