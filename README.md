
# Development using VS Code (containerized)
Getting Started:
```
mkdir -p ./arc-modape-chain
git clone https://github.com/interob/arc-modape-chain.git src
git clone https://github.com/WFP-VAM/modape.git modape
mkdir .devcontainer
ln -s src/development/vscode/.devcontainer/devcontainer.json ./.devcontainer/devcontainer.json
```

Now open the ./arc-modape-chain folder and confirm you wish to Open in Container

# Source Control
When developing inside a Docker container, provide minimum git configuration like so:
```
git config --global user.name "<name>"
git config --global user.email "<email>"
```
