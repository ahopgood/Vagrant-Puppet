#!/usr/bin/env bash

<< --MULTI-LINE-COMMENT--
Testing strategy with single tenancy for minor versions of Java:
Incremental Upgrade tests:
Java 6_34 -> 6_45
Java 7_76 -> 7_80
Java 8_31 -> 8_112

Incremental Downgrade tests:
Java 6_45 -> 6_34
Java 7_80 -> 7_76
Java 8_112 -> 8_31

--MULTI-LINE-COMMENT--

echo "Switching to script execution directory $(dirname $0)"
cd $(dirname $0)

RESULTS_FILE=$(hostname)-results.txt
touch $RESULTS_FILE

# 6u34 upgrade to 6u45
puppet apply --parser=future ../../java6_34_default.pp

puppet apply --parser=future ../../java6_45_default.pp
bash ../java-test.sh -v 6 -u 45 -m 1 | tee -a $RESULTS_FILE

# 6u45 downgrade to 6u34
puppet apply --parser=future ../../java6_34_default.pp
bash ../java-test.sh -v 6 -u 34 -m 1 | tee -a $RESULTS_FILE


# 7u76 upgrade to 7u80
puppet apply --parser=future ../../java7_76_default.pp

puppet apply --parser=future ../../java7_80_default.pp
bash ../java-test.sh -v 7 -u 80 -m 1 | tee -a $RESULTS_FILE

# 7u80 downgrade to 7u76
puppet apply --parser=future ../../java7_76_default.pp
bash ../java-test.sh -v 7 -u 76 -m 1 | tee -a $RESULTS_FILE


# 8u31 upgrade to 8u112
puppet apply --parser=future ../../java8_31_default.pp

puppet apply --parser=future ../../java8_112_default.pp
bash ../java-test.sh -v 8 -u 112 -m 1 | tee -a $RESULTS_FILE

# 8u112 downgrade to 8u
puppet apply --parser=future ../../java8_31_default.pp
bash ../java-test.sh -v 8 -u 31 -m 1 | tee -a $RESULTS_FILE

printf "%s\n" "------------------------------"
printf "%s\n" "Printing off collated results:"
cat $RESULTS_FILE
rm $RESULTS_FILE
