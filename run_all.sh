START=1
END=9

for i in $(seq ${START} ${END});do
  ./${i}_*
done

./test_it.sh
./test_engineering.sh
./test_hr.sh
