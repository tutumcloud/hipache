#!/bin/sh
TEMPLATE=/config.json.j2
CONFIGFILE=/usr/local/lib/node_modules/hipache/config/config_dev.json
sed -i "s|{{ SERVER_ACCESSLOG }}|${SERVER_ACCESSLOG}|g" $TEMPLATE
sed -i "s|{{ SERVER_WORKERS }}|${SERVER_WORKERS}|g" $TEMPLATE
sed -i "s|{{ SERVER_MAXSOCKETS }}|${SERVER_MAXSOCKETS}|g" $TEMPLATE
sed -i "s|{{ SERVER_DEADBACKENDTTL }}|${SERVER_DEADBACKENDTTL}|g" $TEMPLATE
sed -i "s|{{ SERVER_TCPTIMEOUT }}|${SERVER_TCPTIMEOUT}|g" $TEMPLATE
sed -i "s|{{ SERVER_RETRYONERROR }}|${SERVER_RETRYONERROR}|g" $TEMPLATE
sed -i "s|{{ SERVER_DEADBACKENDON500 }}|${SERVER_DEADBACKENDON500}|g" $TEMPLATE
sed -i "s|{{ SERVER_HTTPKEEPALIVE }}|${SERVER_HTTPKEEPALIVE}|g" $TEMPLATE
sed -i "s|{{ SERVER_LRUCACHE_SIZE }}|${SERVER_LRUCACHE_SIZE}|g" $TEMPLATE
sed -i "s|{{ SERVER_LRUCACHE_TTL }}|${SERVER_LRUCACHE_TTL}|g" $TEMPLATE
sed -i "s|{{ SERVER_PORT }}|${SERVER_PORT}|g" $TEMPLATE
sed -i "s|{{ SERVER_ADDRESS }}|${SERVER_ADDRESS}|g" $TEMPLATE
if [ ! -z "$REDIS_PORT_6379_TCP_ADDR" ]; then
	REDIS_HOST=redis
	REDIS_PORT=$REDIS_PORT_6379_TCP_PORT
	REDIS_PASSWORD=$REDIS_ENV_REDIS_PASS
fi

if [ ! -z "$REDIS_HOST" ]; then
	echo "Detected Redis server. Using as driver"
	if [ ! -z "$REDIS_PASSWORD" ]; then
		sed -i "s|{{ DRIVER }}|redis://:${REDIS_PASSWORD}@${REDIS_HOST}:${REDIS_PORT:-6379}/${REDIS_DB:-0}|g" $TEMPLATE
	else
		sed -i "s|{{ DRIVER }}|redis://${REDIS_HOST}:${REDIS_PORT:-6379}/${REDIS_DB:-0}|g" $TEMPLATE
	fi
  # Disable autostart of Redis in current container:
  # add "autostart=false" to [program:redis] (if not yet added).
  sed -i -e '/^\[program:redis\]$/ { N; s/\[program:redis\]\(\nautostart=false\)\?/[program:redis]\nautostart=false/ }' \
      /etc/supervisor/conf.d/supervisord.conf
else
	sed -i "s|{{ DRIVER }}|${DRIVER}|g" $TEMPLATE
fi
cp $TEMPLATE $CONFIGFILE

echo "Using configuration file:"
cat $CONFIGFILE
exec supervisord -n