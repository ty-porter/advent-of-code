LAST_DIR=$(ls solutions | tail -1)
NEW_DIR=$(($LAST_DIR + 1))

mkdir solutions/$NEW_DIR
cd solutions/$NEW_DIR
cp ../../_template.rb main.rb
touch prompt.txt

exec bash