# ARC MODAPE CHAIN
This repositories holds the code base of ARC's MODAPE-based Processing Chain to produce
the Filtered MODIS C6.1 NDVI dataset.

# Development using VS Code (containerized)
Getting Started:
```
mkdir arc-modape-chain && cd arc-modape-chain
git clone https://github.com/interob/arc-modape-chain.git src
git clone https://github.com/interob/modape.git modape
mkdir .devcontainer
ln -s src/development/vscode/.devcontainer/devcontainer.json ./.devcontainer/devcontainer.json
```

Now open the ./arc-modape-chain folder and confirm you wish to Open in Container

The `initializeCommand` in the `devcontainer.json` file takes care of installing (`pip install -e`) the
repos that you checked out (`arc-modape-chain` + `modape`).

# Source Control
When developing inside a Docker container, provide minimum git configuration like so:
```
git config --global user.name "<name>"
git config --global user.email "<email>"
```
