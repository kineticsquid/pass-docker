#!/bin/sh

# Set some defaults.  Either we use what was passed in ENV vars or use default hard-coded values
# Then we set some variables to these values
ACTIVEMQ_PASSWORD=${ACTIVEMQ_PASSWORD:=moo}
ACTIVEMQ_USERNAME=${ACTIVEMQ_USER:=messaging}

# For backwards compatibility:
#   If SPRING_ACTIVEMQ* exist, use those. Otherwise use the defaults from above.
export ACTIVEMQ_PASSWORD=${SPRING_ACTIVEMQ_PASSWORD:=$ACTIVEMQ_PASSWORD}
export ACTIVEMQ_USER=${SPRING_ACTIVEMQ_USER:=$ACTIVEMQ_USER}

envsubst '${ACTIVEMQ_PASSWORD}, ${ACTIVEMQ_USER}' < /activemq.xml > ${ACTIVEMQ_HOME}/conf/activemq.xml

${ACTIVEMQ_HOME}/bin/activemq console