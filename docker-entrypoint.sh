#!/bin/bash
set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
	set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
	if [ "$ELASTICSEARCH_URL" ]; then
		sed -i 's/elasticsearch:9200/'"$ELASTICSEARCH_URL"'/g' /opt/kibana/config/kibana.yml
	fi
  echo "" >> /opt/kibana/config/kibana.yml
  if [ "$ELASTICSEARCH_NAME" ]; then
    echo 'kibana_elasticsearch_username: ELASTICSEARCH_NAME' >> /opt/kibana/config/kibana.yml
    sed -i 's/ELASTICSEARCH_NAME/'"$ELASTICSEARCH_NAME"'/g' /opt/kibana/config/kibana.yml
  fi
  
  if [ "$ELASTICSEARCH_PASSWD" ]; then
    echo 'kibana_elasticsearch_password: ELASTICSEARCH_PASSWD' >> /opt/kibana/config/kibana.yml
    sed -i 's/ELASTICSEARCH_PASSWD/'"$ELASTICSEARCH_PASSWD"'/g' /opt/kibana/config/kibana.yml
  fi

	set -- gosu kibana tini -- "$@"
fi

exec "$@"
