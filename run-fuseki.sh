#!/bin/bash

export HDT_JAVA_PATH=$( perl -MAlien::hdt_java -e 'print Alien::hdt_java->dist_dir' );
export JENA_FUSEKI_PATH=$( perl -MAlien::Jena::Fuseki -e 'print Alien::Jena::Fuseki->dist_dir' );
export FUSEKI_HOME=$JENA_FUSEKI_PATH;
export FUSEKI_BASE=$PWD/_jena-fuseki-run;

export JAVA_OPTIONS=${JENA_FUSEKI_JAVA_OPTIONS:-"-Xmx128G"}
# -Xmx192G
# -Xss256k

if uname -o | grep -qi 'linux'; then
	KEY='vm.max_map_count'
	MIN_VALUE="$(( 256 * 1024 ))" # 256k
	CUR_VALUE=$(sysctl -n $KEY)
	if [ $CUR_VALUE -lt $MIN_VALUE ]; then
		cat <<EOF
## Current value for $KEY=$CUR_VALUE ($(( $CUR_VALUE / 1024 ))k) is too low.
##
## Set $KEY to $(( $MIN_VALUE / 1024 ))k by running:

    $ sudo sysctl -w $KEY=$MIN_VALUE

EOF
		exit 1
	fi
fi

exec /usr/bin/java $JAVA_OPTIONS \
	-Dlog4j.configurationFile=$JENA_FUSEKI_PATH/log4j2.properties \
	-cp $JENA_FUSEKI_PATH/fuseki-server.jar:$HDT_JAVA_PATH/lib/hdt-api-3.0.10.jar:$HDT_JAVA_PATH/lib/hdt-java-core-3.0.10.jar:$HDT_JAVA_PATH/lib/hdt-jena-3.0.10.jar \
	org.apache.jena.fuseki.cmd.FusekiCmd "$@"
