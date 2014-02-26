# A buildpack for hosting static HTML websites on Cloud Foundry using Nginx


## Using this buildpack as-is

Ensure that your app's root folder has an `index.html` or `index.htm` or `Default.htm` file (which will be served as the default page).

Run:

```
cf push --buildpack https://github.com/cloudfoundry-community/nginx-buildpack.git
```

## Custom configuration files

You can customise the configuration by adding a `nginx.conf` to your root folder.

If the buildpack detects this file it will be used in place of the built-in `nginx.conf`, and run through the
same erb processor.  An example of the most basic `nginx.conf` (this is the one included in the build pack's `conf` directory):

```
worker_processes 1;
daemon off;

error_log <%= ENV["APP_ROOT"] %>/nginx/logs/error.log;
events { worker_connections 1024; }

http {
  log_format cloudfoundry '$http_x_forwarded_for - $http_referer - [$time_local] "$request" $status $body_bytes_sent';
  access_log <%= ENV["APP_ROOT"] %>/nginx/logs/access.log cloudfoundry;
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
      root <%= ENV["APP_ROOT"] %>/public;
      index index.html index.htm Default.htm;
    }
  }
}
```

## Building the nginx package

Startup the build-box by using [Vagrant](http://www.vagrantup.com):

```
vagrant up
```

Wait until vagrant finished the provisioning (defined by [provisioning-script](support/provisioning).

Build nginx package:

```
vagrant ssh
/vagrant/support/heroku-buildpack run
mv builds /vagrant
```

Upload the created nginx package from `builds/` to a public available space and change the URL of `compile_nginx_download` in `bin/compile`.
