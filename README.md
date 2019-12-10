# Nginx for Matomo Docker Container Image 

Overview:

* All images are based on Alpine Linux
* Base image: [wodby/php-nginx](https://github.com/wodby/php-nginx)
* [Docker Hub](https://hub.docker.com/r/tomcat2111/redaxo-nginx)

[_(Dockerfile)_]: https://github.com/staegi/docker-redaxo-nginx/tree/master/Dockerfile

## Environment Variables

See more at [wodby/php-nginx](https://github.com/wodby/php-nginx)

| Variable                           | Default Value    | Description |
| ---------------------------------- | ---------------- | ----------- |
| `NGINX_BACKEND_HOST`               |                  |             |
| `NGINX_SERVER_EXTRA_CONF_FILEPATH` | `/var/www/html/` |             |
| `NGINX_SERVER_NAME`                | `matomo`         |             |
| `NGINX_SERVER_ROOT`                | `/var/www/html`  |             |

## Orchestration Actions

See [wodby/nginx](https://github.com/wodby/nginx) for all actions.
