#!/bin/bash
set -eu pipefail

PREVDAY=$(ls | grep day | sort -V | tail -n 1 | tr -d '\n' | tail -c 2)
NEXTDAY=$((PREVDAY + 1))
NEXTDAY_DIR="$NEXTDAY"

mkdir $NEXTDAY_DIR
cp template.cpp $NEXTDAY_DIR/main.cpp
touch $NEXTDAY_DIR/prompt.txt

echo "AoC 2025 Day $NEXTDAY created! Good luck!"
