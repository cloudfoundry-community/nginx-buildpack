#A buildpack and vulcan builder for Nginx.

## Building binaries

```
cd <buildpack-dir>
support/heroku-buildpack run
```

* `download` - *Pulls the sources from Nginx and PCRE.*
* `cleanup` - *Cleans up both builds and sources.*
* `build` - *Initiates a vulcan build on Heroku.*
* `run` - *Runs everything in one clean shot for you.*
* `setup` - *Removes html and copies conf and logs to builds/nginx.*

*The equivs exist inside of `rake` too which will invoke `support/heroku-buildpack`.*<br>
*If you use RVM it will add `support/` to the path so you can just do `heroku-buildpack`.*<br>
*After you have built your binary and uploaded it, update the variable inside of bin/compile.*

## Using this buildpack as is

```
heroku config:add BUILDPACK_URL=https://github.com/envygeeks/heroku-nginx-buildpack.git
```

## Custom configuration files

This buildpack supports a custom configuration file by just adding `nginx.conf` to the `public` folder.
If it detects said file it will use it in place of the built-in nginx.conf and run it through the
same erb processor.  An example of the most basic `nginx.conf`:

```
worker_processes 1;
daemon off;

error_log /app/nginx/logs/error.log;
events { worker_connections 1024; }

http {
  log_format heroku '$http_x_forwarded_for - $http_referer - [$time_local] "$request" $status $body_bytes_sent';
  access_log /app/nginx/logs/access.log heroku;
  default_type application/octet-stream;
  include mime.types;
  sendfile on;
  gzip on;
  tcp_nopush on;
  keepalive_timeout 30;

  server {
    listen <%= ENV["PORT"] %>;
    server_name localhost;

    location ~ /\.ht { deny  all; }
    location / {
      root /app/public;
      index  index.html;
    }
  }
}
```
