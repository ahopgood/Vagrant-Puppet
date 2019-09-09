#!/usr/bin/env bash

<< --MULTI-LINE-COMMENT--
Testing strategy with single tenancy:
Incremental Upgrade tests:
Java 6 -> 7 -> 8

Multi Version Downgrade tests:
Java 8 -> 6

Multi Version Upgrade tests:
Java 6 -> 8

Incremental Downgrade tests:
Java 8 -> 7 -> 6
--MULTI-LINE-COMMENT--

echo "Switching to script execution directory $(dirname $0)"
cd $(dirname $0)
touch results.txt

# 6 upgrade to 7
puppet apply --parser=future ../../java6_45_default.pp

puppet apply --parser=future ../../java7_76_default.pp
bash ../java-test.sh -v 7 -u 76 -m 1 | tee -a results.txt

# 7 upgrade to 8
puppet apply --parser=future ../../java8_31_default.pp
bash ../java-test.sh -v 8 -u 31 -m 1 | tee -a results.txt

# 8 downgrade to 6
puppet apply --parser=future ../../java6_45_default.pp
bash ../java-test.sh -v 6 -u 45 -m 1 | tee -a results.txt

# 6 upgrade to 8
puppet apply --parser=future ../../java8_31_default.pp
bash ../java-test.sh -v 8 -u 31 -m 1 | tee -a results.txt

# 8 downgrade to 7
puppet apply --parser=future ../../java7_76_default.pp
bash ../java-test.sh -v 7 -u 76 -m 1 | tee -a results.txt

# 7 downgrade to 6
puppet apply --parser=future ../../java6_45_default.pp
bash ../java-test.sh -v 6 -u 45 -m 1 | tee -a results.txt

printf "%s\n" "------------------------------"
printf "%s\n" "Printing off collated results:"
cat results.txt
rm results.txt
