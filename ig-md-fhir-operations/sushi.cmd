@echo off
setlocal
set "NODE_HOME=C:\Travail\NodeJS\node-v20.18.1-win-x64\node-v20.18.1-win-x64"
set "PATH=%NODE_HOME%;%PATH%"
"%NODE_HOME%\npx.cmd" --yes fsh-sushi %*
