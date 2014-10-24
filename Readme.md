# DEPRECIATED
This buildpack has been depreciated in favour of the more up to date (and better named) https://github.com/cloudfoundry-community/staticfile-buildpack.  Please use that instead.

---

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

Vagrant was used for building nginx with the latest pcre (8.33 at time of writing)

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu-server-10.04"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"
  config.vm.synced_folder "/your/home/dir", "/nginx"
end
```

Build script

```
#!/bin/sh
# http://jamie.curle.io/blog/compiling-nginx-ubuntu/

pcre_version=8.33
nginx_version=1.5.10

apt-get install -fy build-essential zlib1g-dev

mkdir ~/src
cd ~/src

wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$pcre_version.tar.gz
tar -xzvf pcre-$pcre_version.tar.gz
cd pcre-$pcre_version/
./configure # /usr/local is the default so no need to prefix
make
make install
ldconfig # this is important otherwise nginx will compile but fail to load

cd ~/src
wget http://nginx.org/download/nginx-$nginx_version.tar.gz
tar -xvzf nginx-$nginx_version.tar.gz 
cd nginx-$nginx_version
./configure

make 
make install

cd /usr/local
sudo tar -zcvpf /nginx/nginx-$nginx_version.tar.gz nginx/
```
