#A buildpack and vulcan builder for Nginx on Heroku.

## Building binaries

```
cd <buildpack-dir>
support/heroku-buildpack download
support/heroku-buildpack build
support/heroku-buildpack setup
```
* `download` - *pulls the sources from Nginx and PCRE.*
* `cleanup` - *cleans up both builds and sources.*
* `build` - *initiates a vulcan build on Heroku.*
* `setup` - *removes html and copies conf and logs to builds/nginx.*

*The equivs exist inside of `rake` too which will invoke `support/heroku-buildpack`.*<br>
*If you use RVM it will add `support/` to the path so you can just do `heroku-buildpack`.*<br>
*After you have built your binary and uploaded it, update the variable inside of bin/compile.*

## Using this buildpack as is

```
heroku confi:add BUILDPACK_URL=https://github.com/envygeeks/heroku-nginx-buildpack.git
```
