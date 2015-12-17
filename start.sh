#!/bin/sh

root=~/prod/todosails
sails=`which sails`

forever start --workingDir ${root} -a -l todosails.log ${sails} lift --prod