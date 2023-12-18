#!/bin/bash

export HDT_JAVA_PATH=$( perl -MAlien::hdt_java -e 'print Alien::hdt_java->dist_dir' );
export JENA_FUSEKI_PATH=$( perl -MAlien::Jena::Fuseki -e 'print Alien::Jena::Fuseki->dist_dir' );
export FUSEKI_HOME=$JENA_FUSEKI_PATH;
export FUSEKI_BASE=$PWD/run;

exec /usr/bin/java -Xmx4G \
	-Dlog4j.configurationFile=$JENA_FUSEKI_PATH/log4j2.properties \
	-cp $JENA_FUSEKI_PATH/fuseki-server.jar:$HDT_JAVA_PATH/lib/hdt-api-3.0.10.jar:$HDT_JAVA_PATH/lib/hdt-java-core-3.0.10.jar:$HDT_JAVA_PATH/lib/hdt-jena-3.0.10.jar \
	org.apache.jena.fuseki.cmd.FusekiCmd "$@"
