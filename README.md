tutum-docker-hipache
====================

Extends the official `hipache:0.3.1` image to provide configuration at runtime via environment variables.

The configuration file used is:

	{
	    "server": {
	        "accessLog": "{{ SERVER_ACCESSLOG }}",
	        "workers": {{ SERVER_WORKERS }},
	        "maxSockets": {{ SERVER_MAXSOCKETS }},
	        "deadBackendTTL": {{ SERVER_DEADBACKENDTTL }},
	        "tcpTimeout": {{ SERVER_TCPTIMEOUT }},
	        "retryOnError": {{ SERVER_RETRYONERROR }},
	        "deadBackendOn500": {{ SERVER_DEADBACKENDON500 }},
	        "httpKeepAlive": {{ SERVER_HTTPKEEPALIVE }},
	        "lruCache": {
	            "size": {{ SERVER_LRUCACHE_SIZE }},
	            "ttl": {{ SERVER_LRUCACHE_TTL }}
	        },
	        "port": {{ SERVER_PORT }},
	        "address": ["{{ SERVER_ADDRESS }}"]
	    },
	    "driver": "{{ DRIVER }}"
	}

You can override settings via environment variables when launching the container:

	docker run -d -p 80:80 -e DRIVER="redis://:password@externalredishost" tutum/hipache

The default values are defined in `Dockerfile`:

	ENV SERVER_ACCESSLOG /var/log/hipache-access.log
	ENV SERVER_WORKERS 10
	ENV SERVER_MAXSOCKETS 100
	ENV SERVER_DEADBACKENDTTL 30
	ENV SERVER_TCPTIMEOUT 30
	ENV SERVER_RETRYONERROR 3
	ENV SERVER_DEADBACKENDON500 false
	ENV SERVER_HTTPKEEPALIVE false
	ENV SERVER_LRUCACHE_SIZE 5
	ENV SERVER_LRUCACHE_TTL 5
	ENV SERVER_PORT 80
	ENV SERVER_ADDRESS 0.0.0.0
	ENV DRIVER redis:


Linking a redis container
-------------------------

You can also link a redis container using `redis` as a link name to automatically configure the `driver` setting:

	docker run -d -p 80:80 --link redis:redis tutum/hipache

In this case, there are two other environment variables that apply:

* `REDIS_ENV_REDIS_PASS` (optional) with the password to authenticate to the redis instance. Set automatically if using `tutum/redis` as the image for the redis container.
* `REDIS_DB` with the redis database to use (default: `0`)
