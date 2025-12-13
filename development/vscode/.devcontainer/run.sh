#!/bin/bash
sed -e "s/{{service}}/arc_modape_chain/ig" \
    -e "s/{{user}}/$(id -un)/ig" \
    -e "s#{{dockerfile}}#$(cd ../ && pwd)/.devcontainer/Dockerfile#ig" \
    -e "s#{{context}}#$(cd ../ && pwd)/src/docker#ig" \
    ../src/development/vscode/.devcontainer/docker-compose.development.yml > ./docker-compose.development.yml \
  && cat ../src/docker/Dockerfile > ./Dockerfile \
  && sed -e "s/{{user}}/$(id -un)/ig" ../src/development/vscode/.devcontainer/DockerDevStage.template >> ./Dockerfile
docker compose -f docker-compose.development.yml run --build --remove-orphans arc_modape_chain /bin/bash