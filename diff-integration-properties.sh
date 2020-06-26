#
#  Compara dos archivos ta-integration properties
#  y muestra los registros differentes de uno y de otro
#

PROD=/tmp/prod-integ.$$
NS=/tmp/ns-integ.$$
ENVDIR=$TA_HOME/environ/nonprod/Env/
PROPPATH=/config/secrets/ta-integration.properties

fpath() {
        echo "${ENVDIR}${1}${PROPPATH}"
}

if [ -z "$1" -o -z "$2" ]; then
   echo "Usage: $0 reference-environm  to-check-environm"
   exit 1;
fi

REFERENCE=$(fpath $1)
TOCHECK=$(fpath $2)

if [ ! -f $REFERENCE -o ! -f $TOCHECK ]
then
    echo "$REFERENCE or $TOCHECK do not exist"
    exit 1
fi

awk -F= '{ print $1 }' $REFERENCE | sort > $PROD 
awk -F= '{ print $1 }' $TOCHECK | sort > $NS


echo "----------------------------------------------"
echo "Without space, lines in *$1* not in *$2*"
echo "Indented lines, lines in *$2* not present in *$1*"
echo "----------------------------------------------"

comm -3 $PROD $NS


rm -f $PROD $NS
