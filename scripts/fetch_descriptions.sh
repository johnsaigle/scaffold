#!/bin/bash

# Fetch the pattern descriptions from the main branch of the Fabric repo
curl --silent -L -O https://raw.githubusercontent.com/danielmiessler/Fabric/refs/heads/main/scripts/pattern_descriptions/pattern_descriptions.json

# Format
cat pattern_descriptions.json |jq -r '.patterns[] | "\(.patternName):\(.description)"' > FABRIC.md
