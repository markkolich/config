#!/bin/bash

for i in `cat urls.txt`
do
wget -S -U "Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10" --limit-rate=1m --header="Authorization: Basic SVRUT4o0T0sdfpXazNZc3I=" $i
done

