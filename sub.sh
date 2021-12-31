#!/bin/bash

for i in {1..500}
do
	echo $i
	curl -s localhost:8081/sub/test_____ > /dev/null &
done
