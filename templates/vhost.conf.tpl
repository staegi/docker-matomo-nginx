upstream php {
    server {{ getenv "NGINX_BACKEND_HOST" }}:9000;
}

map $http_x_forwarded_proto $fastcgi_https {
    default $https;
    http '';
    https on;
}

server {
    server_name {{ getenv "NGINX_SERVER_NAME" "matomo" }};
    listen 80 default_server{{ if getenv "NGINX_HTTP2" }} http2{{ end }};

    root {{ getenv "NGINX_SERVER_ROOT" "/var/www/html/" }};
    index {{ getenv "NGINX_INDEX_FILE" "index.php" }};

    include fastcgi.conf;
    include healthz.conf;
    include pagespeed.conf;

    if (!-d $request_filename) {
        rewrite ^/(.+)/$ /$1 permanent;
    }

    ## only allow accessing the following php files
    location ~ ^/(index|matomo|piwik|js/index|plugins/HeatmapSessionRecording/configs)\.php {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        fastcgi_pass php;
        track_uploads uploads 60s;
        add_header X-Frame-Options "";
    }

    location ~ [^/]\.php(/|$) {
        deny all;
        return 403;
    }

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }

    ## disable all access to the following directories
    location ~ /(config|tmp|core|lang) {
        deny all;
        return 403; # replace with 404 to not show these directories exist
    }

    location ~ /\.ht {
        deny  all;
        return 403;
    }

    location ~ js/container_.*_preview\.js$ {
        expires off;
        add_header Cache-Control 'private, no-cache, no-store';
    }

    location ~ \.(gif|ico|jpg|png|svg|js|css|htm|html|mp3|mp4|wav|ogg|avi|ttf|eot|woff|woff2|json)$ {
        allow all;
        ## Cache images,CSS,JS and webfonts for an hour
        ## Increasing the duration may improve the load-time, but may cause old files to show after an Matomo upgrade
        expires 1h;
        add_header Pragma public;
        add_header Cache-Control "public";
    }

    location ~ /(libs|vendor|plugins|misc/user) {
        deny all;
        return 403;
    }

    ## properly display textfiles in root directory
    location ~/(.*\.md|LEGALNOTICE|LICENSE) {
        default_type text/plain;
    }

    #!!! WICHTIG !!! Falls Let's Encrypt fehlschlägt, diese Zeile auskommentieren (sollte jedoch funktionieren)
    location ~ /\. { deny  all; }

{{ if getenv "NGINX_SERVER_EXTRA_CONF_FILEPATH" }}
    include {{ getenv "NGINX_SERVER_EXTRA_CONF_FILEPATH" }};
{{ end }}
}
