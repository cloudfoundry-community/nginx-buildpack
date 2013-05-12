#A buildpack and vulcan builder for Nginx.

## Building binaries

```
cd <buildpack-dir>
support/heroku-buildpack run
```

* `download` - *pulls the sources from Nginx and PCRE.*
* `cleanup` - *cleans up both builds and sources.*
* `build` - *initiates a vulcan build on Heroku.*
* `run` - *Runs everything in one clean shot for you.*
* `setup` - *removes html and copies conf and logs to builds/nginx.*

*The equivs exist inside of `rake` too which will invoke `support/heroku-buildpack`.*<br>
*If you use RVM it will add `support/` to the path so you can just do `heroku-buildpack`.*<br>
*After you have built your binary and uploaded it, update the variable inside of bin/compile.*

## Using this buildpack as is

```
heroku config:add BUILDPACK_URL=https://github.com/envygeeks/heroku-nginx-buildpack.git
```
