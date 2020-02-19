#
#  Clean package + install locally root and ta-common.
#
#

mvn clean package $* \
    && mvn --non-recursive install $* \
    && mvn -Dmaven.test.skip=true -pl ta-common install $*  \
    && mvn -Dmaven.test.skip=true -pl repro-commons install $*

