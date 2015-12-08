#!/bin/sh

root=~/prod/util.auth
http=node_modules/.bin/http-server

forever start --workingDir ${root} -l util.auth.log ${http} ./test -p 8014