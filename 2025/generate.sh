#!/bin/bash
set -eu pipefail

PREVDAY=$(ls | grep -P "\d+" | sort -V | tail -n 1 | tr -d '\n')
NEXTDAY=$(printf "%02d" $((PREVDAY + 1)))
NEXTDAY_DIR="$NEXTDAY"

mkdir $NEXTDAY_DIR
cp main.cpp.tpl $NEXTDAY_DIR/main.cpp
touch $NEXTDAY_DIR/prompt.txt

echo "AoC 2025 Day $NEXTDAY created! Good luck!"
