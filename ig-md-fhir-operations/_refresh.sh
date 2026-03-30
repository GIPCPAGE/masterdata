#!/bin/bash
echo "Refreshing package cache..."
java -jar input-cache/publisher.jar -refresh -ig ig.ini
echo "Package cache refreshed."