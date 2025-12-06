#!/bin/bash
set -eu pipefail

PREVDAY=$(ls | grep -P "\d+" | sort -V | tail -n 1 | tr -d '\n')
NEXTDAY="$(printf "%02d" $((10#$PREVDAY + 1)))"
DAYNUM=$((10#$NEXTDAY)) # Strip leading zeros for map key

# Create directory and files
mkdir $NEXTDAY
sed "s/{{DAY}}/$NEXTDAY/g" solution.hpp.tpl > $NEXTDAY/solution.hpp
touch $NEXTDAY/prompt.txt

# A good enough hack to update main.cpp for each solution.
# 1. Add includes list
LAST_INCLUDE=$(grep -n '#include "[0-9]\{2\}/solution.hpp"' main.cpp | tail -1 | cut -d: -f1)
sed -i "${LAST_INCLUDE}a #include \"$NEXTDAY/solution.hpp\"" main.cpp

# 2. Add to DAYS map
sed -i "/^const std::map<int, std::function<void()>> DAYS = {$/,/^};$/ {
  /^};$/i \  {$DAYNUM, []() { day$NEXTDAY::run(); }},
}" main.cpp

echo "AoC 2025 Day $NEXTDAY created! Good luck!"
