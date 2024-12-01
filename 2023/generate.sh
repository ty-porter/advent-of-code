#!/bin/bash
set -eu pipefail

PREVDAY=$(ls | grep day | sort -V | tail -n 1 | tr -d '\n' | tail -c 2)
NEXTDAY=$((PREVDAY + 1))
NEXTDAY_DIR="day$NEXTDAY"

echo "Created directory $NEXTDAY_DIR"

mkdir $NEXTDAY_DIR

pushd $NEXTDAY_DIR

# Copy go template
cp ../main.go.template main.go

# Copy the day into the go template input path lookup
sed -i '' "s/<#>/$NEXTDAY/g" main.go

# Init the mod
go mod init

# Copy blank inputs for test input and actual input
touch test.txt
touch input.txt

popd

echo "AoC 2023 Day $NEXTDAY scaffold created! Good luck!"
